# encoding: utf-8
# Cookbook Name:: icinga
# Recipe:: client
#
# Copyright 2012, BigPoint GmbH
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install required packages based on platform
pkgs = value_for_platform_family(
  'windows' => %w( ),
  'rhel' => %w( xinetd ethtool ),
  'debian' => %w( xinetd ethtool ),
  'default' => %w( xinetd ethtool )
)
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

package 'check-mk-agent-logwatch' do
  action :purge
  only_if { node['platform_family'] == 'debian' || node['platform_family'] == 'rhel' }
end

version = node['check_mk']['version']

remote_file "#{Chef::Config[:file_cache_path]}/check_mk-#{version}.tar.gz" do
  source "#{node['check_mk']['url']}/check_mk-#{version}.tar.gz"
  mode '0644'
  checksum node['check_mk']['source']['tar']['checksum']
  action :create_if_missing
  notifies :run, 'bash[extract_cmk_source]', :immediately
end

bash 'extract_cmk_source' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    tar -xzf check_mk-#{version}.tar.gz
  EOF
  action :nothing
  notifies :run, 'bash[extract_agents]', :immediately
end

bash 'extract_agents' do
  cwd Chef::Config[:file_cache_path] + "/check_mk-#{version}/"
  code <<-EOF
    tar -xzf agents.tar.gz
  EOF
  action :nothing
end

# Platform specific installation path  : Debian
case node['platform_family']
when 'debian'

  package 'check-mk-agent-debian' do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check_mk-#{version}/check-mk-agent_#{version}-1_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

  # CVE-2014-0243
  directory '/var/lib/check_mk_agent/job' do
    user 'root'
    group 'root'
    action :create
    recursive true
    mode 0755
  end

when 'rhel'
  package 'check-mk-agent-rhel' do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check_mk-#{version}/check-mk-agent_#{version}-1.noarch.rpm"
    provider Chef::Provider::Package::Dpkg
  end
end

# install logwatch plugin
bash 'install_logwatch' do
  cwd "#{Chef::Config[:file_cache_path]}/check_mk-#{version}/plugins/"
  code <<-EOF
    cp mk_logwatch #{node['check_mk']['setup']['agentslibdir']}/plugins/
  EOF
  not_if { ::File.exist?("#{node['check_mk']['setup']['agentslibdir']}/plugins/mk_logwatch") }
end

# runs /etc/init.d/xinetd (start|stop|restart), etc.
service 'xinetd' do
  supports 'status' => false, 'restart' => true, 'reload' => true
  action [:enable, :start]
end

# Reload xinetd if config changed
template '/etc/xinetd.d/check_mk' do
  source 'check_mk/client/check_mk.erb'
  owner 'root'
  group 'root'
  mode 0640
  notifies :reload, 'service[xinetd]'
end

%w(mk_mysql mk_postgres).each do |plugin|
  cookbook_file "#{node['check_mk']['setup']['agentslibdir']}/plugins/#{plugin}" do
    source "plugins/linux/#{plugin}"
    mode 0750
  end
end

template '/etc/check_mk/logwatch.cfg' do
  source 'check_mk/client/logwatch.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  variables('entries' => node['check_mk']['logwatch']['entries'])
end
