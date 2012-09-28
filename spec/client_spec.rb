require 'chefspec'

%w{ debian centos ubuntu fedora redhat }.each do |platform|
  describe "The icinga::client #{platform} Recipe" do
    before (:all) {
      @chef_run = ChefSpec::ChefRunner.new
      @chef_run.node.automatic_attrs[:platform] = platform
      @chef_run.converge 'icinga::client'
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

    # Check that our template file is created to enable the check_mk agent
    it "should create file /etc/xinet.d/check_mk" do
      @chef_run.should create_file "/etc/xinetd.d/check_mk"
    end
  end
end