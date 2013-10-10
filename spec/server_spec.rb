# encoding: utf-8
#
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
{ 'debian' => '7.1' }.each do |platform, version|
  describe "The icinga::server #{platform} recipe" do
    let(:chef_run) do
      runner = ChefSpec::Runner.new(
        platform: platform,
        version: version
      )
      env = Chef::Environment.new
      env.name '_default'
      runner.node.stub(:chef_environment).and_return env.name
      runner.stub(:chef_environment).and_return(env.name)
      Chef::Environment.stub(:load).and_return env

      # Required for file/directory ownerships
      runner.node.set['apache'] = { 'user' => 'www-data', 'group' => 'www-data' }
      runner.node.set['icinga'] = { 'user' => 'nagios', 'group' => 'nagios' }

      # Required for template file name
      runner.node.set['check_mk'] = {
        'legacy' => {
          'checks' => {
            'apache2::mod_ssl' => { 'name' => 'check-http', 'opts' => '-p 443 -S',
                                    'alias' => 'Legacy_HTTPs', 'perfdata' => 'True' },
            'apache2' => { 'name' => 'check-http', 'opts' => '-p 80',
                           'alias' => 'Legacy_HTTP', 'perfdata' => 'True' }
          },
          'commands' => {
            'check-http' => { 'name' => 'check-http',
                              'line' => '$USER1$/check_http -I $HOSTADDRESS$ $ARG1$' },
            'check-tcp' => { 'name' => 'check-tcp',
                             'line' => '$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$' }
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
        },
        'setup' => { 'vardir' => '/var/lib/check_mk' }
      }
      runner.converge 'icinga::server'
      runner
    end

    before do
      stub_data_bag_item('groups', 'check-mk-admin').and_return(
        {
          'id' => 'check-mk-admin',
          '_default' => { 'members' => ['icingaadmin'] }
        }
      )
      stub_data_bag_item('users', 'icingaadmin').and_return(
        { 'id' => 'icingaadmin', 'htpasswd' => 'plaintext' }
      )
      stub_search('node', 'hostname:[* TO *] AND chef_environment:_default').and_return(
        [{ 'chef_environment' => '_default', 'hostname' => 'Fauxhai',
           'roles' => ['monitoring-server'], 'tags' => ['testing'], 'os' => 'linux',
           'recipes' => ['apache2'], 'lsb' => { 'codename' => platform }
        }]
      )
      stub_search('role', 'name:*').and_return(['role[monitoring-server]'])
    end

    # Check if all packages required are installed
    %w(xinetd python).each do |pkg|
      it "should install #{pkg}" do
        expect(chef_run).to install_package pkg
      end
    end

    it 'should install icinga icinga-core icinga-cgi' do
      expect(chef_run).to install_package 'icinga icinga-core icinga-cgi'
    end

    # Check that services used are enabled for bootup and started when installed
    %w(icinga xinetd).each do |service|
      it "should enable and start service #{service} on boot" do
        expect(chef_run).to enable_service(service)
        expect(chef_run).to start_service service
      end
    end

    # Check for all directories created
    %w(/var/lib/check_mk/web/icingaadmin).each do |dir|
      it "should create path #{dir}" do
        expect(chef_run).to create_directory dir
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
       /etc/check_mk/conf.d/hostgroups-Fauxhai.mk
       /etc/check_mk/conf.d/global-configuration.mk
       /etc/check_mk/conf.d/legacy-checks.mk
       /etc/check_mk/conf.d/ignored_services.mk
       /etc/check_mk/conf.d/ignored_checks.mk
       /etc/check_mk/multisite.d/wato/users.mk
    ).each do |file|
      it "should create file from template #{file}" do
        expect(chef_run).to render_file file
      end
    end

    it 'should notify template creation for /root/.check_mk_setup.conf' do
      expect(chef_run.remote_file(
        "#{Chef::Config[:file_cache_path]}/check_mk-#{chef_run.node['check_mk']['version']}.tar.gz")
      ).to notify('template[/root/.check_mk_setup.conf]').to(:create)
    end

    it 'should notify source compile script' do
      expect(chef_run.remote_file(
        "#{Chef::Config[:file_cache_path]}/check_mk-#{chef_run.node['check_mk']['version']}.tar.gz")
      ).to notify('bash[build_check_mk]').to(:run)
    end

    %w(redis).each do |check|
      it "should create service check #{check}" do
        expect(chef_run).to render_file "/usr/share/check_mk/checks/#{check}"
      end
    end

    # Check file and directory ownerships
    %w(/etc/icinga/htpasswd.users).each do |dir|
      it "#{dir} should be owned by www-data:nagios" do
        expect(chef_run).to create_file(dir).with(user: 'www-data', group: 'nagios')
      end
    end

    # Ensure check_mk re-scans all found hosts and reloads Icinga if the templates changed
    it 'should notify check_mk re-inventory, reload and restart' do
      expect(chef_run.template('/etc/check_mk/conf.d/hostgroups-Fauxhai.mk')).to notify(
        'execute[reload-check-mk]'
      ).to(:run)
      expect(chef_run.template('/etc/check_mk/conf.d/wato/rules.mk')).to notify(
        'execute[restart-check-mk]'
      ).to(:run)
    end
  end
end
