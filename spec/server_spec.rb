# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chefspec'

# Required for proper recipe testing by platform
%w(debian).each do |platform|
  %w(squeeze wheezy).each do |codename|
    describe "The icinga::server #{platform} #{codename} recipe" do
      let(:chef_run) do
        # Define some data bag items and searches that are used in the recipe
        Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
        Chef::Recipe.any_instance.stub(:data_bag_item).with('groups', 'check-mk-admin').and_return(
          {
            'id' => 'check-mk-admin',
            '_default' => { 'members' => ['icingaadmin'] }
          }
        )
        Chef::Recipe.any_instance.stub(:data_bag_item).with('users', 'icingaadmin').and_return('id' => 'icingaadmin', 'htpasswd' => 'plaintext')
        Chef::Recipe.any_instance.stub(:search).with(:node, 'hostname:[* TO *] AND chef_environment:_default').and_return(
          [{ 'chef_environment' => '_default', 'hostname' => 'localhost', 'roles' => ['monitoring-server'],
             'tags' => ['testing'], 'os' => 'linux', 'recipes' => ['apache2'], 'lsb' => { 'codename' => codename }
          }]
        )
        Chef::Recipe.any_instance.stub(:search).with(:role, 'name:*').and_return(['role[monitoring-server]'])
        Chef::Recipe.any_instance.stub(:search).with(:environment, 'name:*').and_return(['_default'])

        # Create our object
        runner = ChefSpec::ChefRunner.new
        # Required for template path testing
        runner.node.set['check_mk'] = { 'setup' => { 'vardir' => '/var/lib/check_mk' } }
        env = Chef::Environment.new
        env.name '_default'
        runner.node.stub(:chef_environment).and_return env.name
        Chef::Environment.stub(:load).and_return env

        # Required for file/directory ownerships
        runner.node.set['apache'] = { 'user' => 'www-data', 'group' => 'www-data' }
        runner.node.set['icinga'] = { 'user' => 'nagios', 'group' => 'nagios' }

        # Required for template file name
        runner.node.automatic_attrs['hostname'] = 'localhost'
        runner.node.automatic_attrs['chef_environment'] = '_default'
        runner.node.automatic_attrs['platform'] = platform
        runner.node.automatic_attrs['platform_family'] = platform
        runner.node.automatic_attrs['lsb'] = { 'codename' => codename }
        runner.node.set['check_mk'] = {
          'legacy' => {
            'checks' => {
              'apache2::mod_ssl' => { 'name' => 'check-http', 'opts' => '-p 443 -S', 'alias' => 'Legacy_HTTPs', 'perfdata' => 'True' },
              'apache2' => { 'name' => 'check-http', 'opts' => '-p 80', 'alias' => 'Legacy_HTTP', 'perfdata' => 'True' }
            },
            'commands' => {
              'check-http' => { 'name' => 'check-http', 'line' => '$USER1$/check_http -I $HOSTADDRESS$ $ARG1$' },
              'check-tcp' => { 'name' => 'check-tcp', 'line' => '$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$' }
            }
          },
          'config' => {
            'ignored_services' => [
              'ALL_HOSTS, [ "Monitoring" ]',
              'ALL_HOSTS, [ "NFS mount .*" ]'
            ],
            'ignored_checks' => [
              '[ "mysql_capacity" ], ALL_HOSTS',
              '[ "mysql_status" ], ALL_HOSTS'
            ]
          }
        }
        runner.converge 'icinga::server'
        runner
      end

      # Check if all packages required are installed
      %w(xinetd python).each do |pkg|
        it "should install #{pkg}" do
          chef_run.should install_package pkg
        end
      end

      it 'should install icinga icinga-core icinga-cgi' do
        chef_run.should install_package 'icinga icinga-core icinga-cgi'
      end

      # Check that services used are enabled for bootup and started when installed
      %w(icinga xinetd).each do |service|
        it "should enable and start service #{service} on boot" do
          chef_run.should set_service_to_start_on_boot service
          chef_run.should start_service service
        end
      end

      # Check for all directories created
      %w(/var/lib/check_mk/web/icingaadmin).each do |dir|
        it "should create path #{dir}" do
          chef_run.should create_directory dir
        end
      end

      # Check all templated files were created
      %w(/etc/check_mk/multisite.mk
         /etc/check_mk/multisite.d/business-intelligence.mk
         /etc/check_mk/multisite.d/wato-configuration.mk
         /etc/check_mk/multisite.d/wato/users.mk
         /etc/icinga/icinga.cfg
         /etc/xinetd.d/livestatus
         /etc/icinga/htpasswd.users
         /etc/check_mk/conf.d/wato/hosts.mk
         /etc/check_mk/conf.d/hostgroups-localhost.mk
         /etc/check_mk/conf.d/global-configuration.mk
         /etc/check_mk/conf.d/legacy-checks.mk
         /etc/check_mk/conf.d/ignored_services.mk
         /etc/check_mk/conf.d/ignored_checks.mk
      ).each do |file|
        it "should create file from template #{file}" do
          chef_run.should create_file file
        end
      end

      #    it 'should download check_mk source' do
      #      chef_run.should create_remote_file "#{Chef::Config[:file_cache_path]}/check_mk-#{chef_run.node['check_mk']['version']}.tar.gz"
      #    end

      it 'should notify template creation for /root/.check_mk_setup.conf' do
        chef_run.remote_file("#{Chef::Config[:file_cache_path]}/check_mk-#{chef_run.node['check_mk']['version']}.tar.gz").should notify 'template[/root/.check_mk_setup.conf]', 'create'
      end

      it 'should notify source compile script' do
        chef_run.remote_file("#{Chef::Config[:file_cache_path]}/check_mk-#{chef_run.node['check_mk']['version']}.tar.gz").should notify 'bash[build_check_mk]', 'run'
      end

      it 'should create hostgroups-localhost.mk with four hostgroups' do
        ['host_groups += [',
         '( \'role: monitoring-server\', [ \'monitoring-server\' ], ALL_HOSTS ),',
         '( \'environment: _default\', [ \'_default\' ], ALL_HOSTS ),',
         '( \'tag: testing\', [ \'testing\' ], ALL_HOSTS ),',
         '( \'os: linux\', [ \'linux\' ], ALL_HOSTS ),'
        ].each do |content|
          chef_run.should create_file_with_content('/etc/check_mk/conf.d/hostgroups-localhost.mk', content)
        end
      end

      it 'should create users.mk with at least one use' do
        chef_run.should create_file_with_content(
          '/etc/check_mk/multisite.d/wato/users.mk',
          "'icingaadmin': {"
        )
      end

      it 'should create htpasswd.users' do
        chef_run.should create_file '/etc/icinga/htpasswd.users'
      end

      it 'should create ignored_services.mk with lines' do
        ['( ALL_HOSTS, [ "Monitoring" ] ),',
         '( ALL_HOSTS, [ "NFS mount .*" ] ),'
        ].each do |content|
          chef_run.should create_file_with_content('/etc/check_mk/conf.d/ignored_services.mk', content)
        end
      end

      it 'should create ignored_checks.mk with lines' do
        ['( [ "mysql_capacity" ], ALL_HOSTS ),',
         '( [ "mysql_status" ], ALL_HOSTS )'
        ].each do |content|
          chef_run.should create_file_with_content('/etc/check_mk/conf.d/ignored_checks.mk', content)
        end
      end

      %w(redis).each do |check|
        it "should create service check #{check}" do
          chef_run.should create_cookbook_file "/usr/share/check_mk/checks/#{check}"
        end
      end

      it 'should create hosts.mk with at least one node' do
        chef_run.should create_file_with_content(
          '/etc/check_mk/conf.d/wato/hosts.mk',
          '\'localhost|all|' + codename + '|site:localhost|linux|_default|monitoring-server|testing\','
        )
      end

      it 'should create legacy-checks.mk with command definitions' do
        ['extra_nagios_conf += r"""',
         'define command',
         'command_name    check-http',
         'command_line    $USER1$/check_http -I $HOSTADDRESS$ $ARG1$',
         'command_name    check-tcp',
         'command_line    $USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$',
         'legacy_checks += [',
         '( ( "check-http!-p 80", "Legacy_HTTP", True), [ "localhost" ] ),'
        ].each do |content|
          chef_run.should create_file_with_content('/etc/check_mk/conf.d/legacy-checks.mk', content)
        end
      end

      # Check file and directory ownerships
      %w(/etc/icinga/htpasswd.users).each do |dir|
        it "#{dir} should be owned by www-data:nagios" do
          chef_run.file(dir).should be_owned_by('www-data', 'nagios')
        end
      end

      # Ensure check_mk re-scans all found hosts and reloads Icinga if the templates changed
      it 'should execute check_mk re-inventory and restart' do
        chef_run.should execute_command 'check_mk -II ; check_mk -R'
      end
    end
  end
end
