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
#
require 'chefspec'

%w(debian rhel).each do |platform_family|
  describe "The icinga::client #{platform_family} recipe" do
    before (:all) {
      @chef_run = ChefSpec::ChefRunner.new
      @chef_run.node.automatic_attrs["platform_family"] = platform_family
      @chef_run.node.automatic_attrs["os"] = "linux"
      @chef_run.node.set["check_mk"] = {
        "setup" => { "agentslibdir" => "/usr/lib/check_mk_agent" }
      }
      @chef_run.converge "icinga::client"
    }

    # Check all packages that are installed
    %w(xinetd ethtool).each do |pkg|
      it "should install #{pkg}" do
        @chef_run.should install_package pkg
      end
    end

    # Ensure we notify our package installer after download
    it "should notify package installation" do
      case platform_family
        when 'debian'
          file_agent = "/var/cache/apt/archives/check-mk-agent_#{@chef_run.node['check_mk']['version']}-#{@chef_run.node['check_mk']['deb']['release']}_all.deb"
          file_logwatch = "/var/cache/apt/archives/check-mk-agent-logwatch_#{@chef_run.node['check_mk']['version']}-#{@chef_run.node['check_mk']['deb']['release']}_all.deb"
        when 'rhel'
          file_agent = "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{@chef_run.node['check_mk']['version']}-#{@chef_run.node['check_mk']['rpm']['release']}.noarch.rpm"
          file_logwatch =  "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{@chef_run.node['check_mk']['version']}-#{@chef_run.node['check_mk']['rpm']['release']}.noarch.rpm"
      end
      @chef_run.remote_file(file_agent).should notify 'package[check-mk-agent]', 'install'
      @chef_run.remote_file(file_logwatch).should notify 'package[check-mk-agent-logwatch]', 'install'
    end

    # Check that our xinetd service is enabled and running
    it "should start xinetd and enabled it boot" do
      @chef_run.should set_service_to_start_on_boot 'xinetd'
      @chef_run.should start_service 'xinetd'
    end

    # Check all templated files were created
    %w(/etc/xinetd.d/check_mk).each do |file|
      it "should create file from template #{file}" do
        @chef_run.should create_file file
      end
    end

    # Check all files are copied
    %w(/usr/lib/check_mk_agent/plugins/apache_status
       /usr/lib/check_mk_agent/plugins/mk_jolokia
       /usr/lib/check_mk_agent/plugins/mk_mysql
       /usr/lib/check_mk_agent/plugins/mk_postgres
    ).each do |file|
      it "should copy file #{file}" do
        @chef_run.should create_cookbook_file file
      end
    end
  end
end
