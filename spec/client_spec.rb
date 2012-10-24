require 'chefspec'

%w{ debian centos ubuntu fedora redhat }.each do |platform|
  describe "The icinga::client #{platform} recipe" do
    before (:all) {
      @chef_run = ChefSpec::ChefRunner.new
      @chef_run.node.automatic_attrs["platform"] = platform
      @chef_run.node.automatic_attrs["os"] = "linux"
      @chef_run.node.set["check_mk"] = {
        "setup" => { "agentslibdir" => "/usr/lib/check_mk_agent" }
      }
      @chef_run.converge "icinga::client"
    }

    # Check all packages that are installed
    %w( xinetd ethtool check-mk-agent check-mk-agent-logwatch ).each do |pkg|
      it "should install #{pkg}" do
        @chef_run.should install_package pkg
      end
    end

    # Check that our xinetd service is enabled and running
    it "should start xinetd and enabled it boot" do
      @chef_run.should set_service_to_start_on_boot 'xinetd'
      @chef_run.should start_service 'xinetd'
    end

    # Check all templated files were created
    %w{
      /etc/xinetd.d/check_mk
    }.each do |file|
      it "should create file from template #{file}" do
        @chef_run.should create_file file
      end
    end

    # Check all files are copied
    %w{
      /usr/lib/check_mk_agent/plugins/apache_status
      /usr/lib/check_mk_agent/plugins/mk_jolokia
      /usr/lib/check_mk_agent/plugins/mk_mysql
      /usr/lib/check_mk_agent/plugins/mk_postgres
    }.each do |file|
      it "should copy file #{file}" do
        @chef_run.should create_cookbook_file file
      end
    end
  end
end
