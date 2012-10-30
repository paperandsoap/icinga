require 'chefspec'

# Required for proper recipe testing by platform
%w{ debian }.each do |platform|
  describe "The icinga::server #{platform} recipe" do
    let (:chef_run) {
      # Define some data bag items and searches that are used in the recipe
      Chef::Recipe.any_instance.stub(:data_bag_item).and_return(Hash.new)
      Chef::Recipe.any_instance.stub(:data_bag_item).with("groups", "check-mk-admin").and_return(
        {
          "id" => "check-mk-admin",
          "members" => ["icingaadmin"]
        }
      )
      Chef::Recipe.any_instance.stub(:data_bag_item).with("users", "icingaadmin").and_return("id" => "icingaadmin", "htpasswd" => "plaintext")
      Chef::Recipe.any_instance.stub(:search).with(:node, 'hostname:[* TO *] AND chef_environment:_default').and_return(
        [ { 'chef_environment' => '_default', 'hostname' => 'localhost', 'roles' => ["monitoring-server"], 'tags' => ["testing"],
            'os' => "linux", "recipes" => ["apache2"], "lsb" => { "codename" => "squeeze" } } ]
      )
      Chef::Recipe.any_instance.stub(:search).with(:role, 'name:*').and_return(["role\[monitoring-server\]"])
      Chef::Recipe.any_instance.stub(:search).with(:environment, 'name:*').and_return(['_default'])

      # Create our object
      runner = ChefSpec::ChefRunner.new
      # Required for template path testing
      runner.node.set["check_mk"] = { "setup" => {"vardir" => "/var/lib/check_mk" } }

      # Required for file/directory ownerships
      runner.node.set["apache"] = { "user" => "www-data", "group" => "www-data" }
      runner.node.set["icinga"] = { "user" => "nagios", "group" => "nagios" }

      # Required for template file name
      runner.node.automatic_attrs["hostname"] = "localhost"
      runner.node.automatic_attrs["platform"] = platform
      runner.node.automatic_attrs["lsb"] = { "codename" => "squeeze" }
      runner.node.set["check_mk"] = {
        "legacy"=> {
          "checks" => {
            "apache2::mod_ssl" => { "name" => "check-http", "opts" => "-p 443 -S", "alias" => "Legcay_HTTPs", "perfdata" => "True" },
            "apache2" => { "name" => "check-http", "opts" => "-p 80", "alias" => "Legacy_HTTP", "perfdata" => "True" }
          },
          "commands" => {
            "check-http" => { "name" => "check-http", "line" => "$USER1$/check_http -I $HOSTADDRESS$ $ARG1$" },
            "check-tcp" => { "name" => "check-tcp", "line" => "$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$" }
          }
        }
      }
      runner.converge 'icinga::server'
      runner
    }

    # Check if all packages required are installed
    %w{ openssl ssl-cert xinetd python rrdcached icinga icinga-cgi icinga-core icinga-doc pnp4nagios }.each do |pkg|
      it "should install #{pkg}" do
        chef_run.should install_package pkg
      end
    end

    # Check that services used are enabled for bootup and started when installed
    %w{ icinga npcd xinetd rrdcached }.each do |service|
      it "should enable and start service #{service} on boot" do
        chef_run.should set_service_to_start_on_boot service
        chef_run.should start_service service
      end
    end

    # Check for all directories created
    %w{ /var/lib/check_mk/web/icingaadmin }.each do |dir|
      it "should create path #{dir}" do
        chef_run.should create_directory dir
      end
    end

    # Check all templated files were created
    %w{
      /root/.check_mk_setup.conf
      /etc/apache2/conf.d/pnp4nagios.conf
      /etc/pnp4nagios/apache.conf
      /etc/default/npcd
      /etc/pnp4nagios/process_perfdata.cfg
      /etc/default/rrdcached
      /etc/pnp4nagios/config.php
      /etc/check_mk/multisite.mk
      /etc/check_mk/multisite.d/business-intelligence.mk
      /etc/check_mk/multisite.d/wato-configuration.mk
      /etc/check_mk/multisite.d/users.mk
      /etc/icinga/icinga.cfg
      /etc/xinetd.d/livestatus
      /usr/share/check_mk/check_mk_templates.cfg
      /var/lib/check_mk/web/icingaadmin/sidebar.mk
      /etc/icinga/htpasswd.users
      /etc/check_mk/multisite.d/users.mk
      /etc/check_mk/conf.d/monitoring-nodes-localhost.mk
      /etc/check_mk/conf.d/hostgroups-localhost.mk
      /etc/check_mk/conf.d/global-configuration.mk
      /etc/check_mk/conf.d/legacy-checks.mk
    }.each do |file|
      it "should create file from template #{file}" do
        chef_run.should create_file file
      end
    end

    it "should create hostgroups-localhost.mk with four hostgroups" do
      [
        "host_groups += [",
        "( 'role: monitoring-server', [ 'monitoring-server' ], ALL_HOSTS ),",
        "( 'environment: _default', [ '_default' ], ALL_HOSTS ),",
        "( 'tag: testing', [ 'testing' ], ALL_HOSTS ),",
        "( 'os: linux', [ 'linux' ], ALL_HOSTS ),"
      ].each do |content|
        chef_run.should create_file_with_content('/etc/check_mk/conf.d/hostgroups-localhost.mk', content)
      end
    end

    it "should create users.mk with at least one use" do
      chef_run.should create_file_with_content(
        '/etc/check_mk/multisite.d/users.mk',
        "'icingaadmin': {'alias': u' ', 'locked': True, 'roles': ['admin']},"
      )
    end

    it "should create htpasswd.users with at least one user" do
      chef_run.should create_file_with_content(
        '/etc/icinga/htpasswd.users',
        "icingaadmin:plaintext"
      )
    end

    it "should create monitoring-nodes-localhost.mk with at least one node" do
      chef_run.should create_file_with_content(
        '/etc/check_mk/conf.d/monitoring-nodes-localhost.mk',
        '\'localhost|squeeze|site:localhost|chefspec|_default|monitoring-server|testing\','
      )
    end

    it "should create legacy-checks.mk with command definitions" do
      [
        "extra_nagios_conf += r\"\"\"",
        "define command",
        "command_name    check-http",
        "command_line    $USER1$/check_http -I $HOSTADDRESS$ $ARG1$",
        "command_name    check-tcp",
        "command_line    $USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$",
        "legacy_checks += [",
        "( ( \"check-http!-p 80\", \"Legacy_HTTP\", True), [ \"localhost\" ] ),"
      ].each do |content|
        chef_run.should create_file_with_content('/etc/check_mk/conf.d/legacy-checks.mk', content)
      end
    end

    # Check file and directory ownerships
    %w{ /etc/icinga/htpasswd.users }.each do |dir|
      it "#{dir} should be owned by www-data:nagios" do
        chef_run.file(dir).should be_owned_by('www-data', 'nagios')
      end
    end

    # Ensure check_mk re-scans all found hosts and reloads Icinga if the templates changed
    it "should execute check_mk re-inventory and reload" do
      chef_run.should execute_command "check_mk -I ; check_mk -O"
    end
  end
end
