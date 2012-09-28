require 'chefspec'

%w{ debian centos ubuntu fedora redhat }.each do |platform|
  describe "The icinga::client #{platform} Recipe" do
    before (:all) {
      @chef_run = ChefSpec::ChefRunner.new
      @chef_run.node.automatic_attrs[:platform] = platform
      @chef_run.converge 'icinga::client'
    }

    %w( xinetd ethtool check-mk-agent check-mk-agent-logwatch ).each do |pkg|
      it "should install #{pkg}" do
        @chef_run.should install_package pkg
      end
    end
    it "should start xinetd on boot" do
      @chef_run.should set_service_to_start_on_boot 'xinetd'
    end
    it "should start xinetd" do
      @chef_run.should start_service 'xinetd'
    end
    it "should create file /etc/xinet.d/check_mk" do
      @chef_run.should create_file "/etc/xinetd.d/check_mk"
    end
  end
end