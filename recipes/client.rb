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
  'windows' => %w{ },
  'rhel' => %w{ xinetd ethtool },
  'debian' => %w{ xinetd ethtool },
  'default' => %w{ xinetd ethtool }
)
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# Platform specific installation path  : Debian
case node['platform_family']
when 'debian'
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + '-' +
    node['check_mk']['deb']['release']

  remote_file "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb" do
    source "#{node['check_mk']['url']}/check-mk-agent_#{version}_all.deb"
    mode '0644'
    checksum node['check_mk']['agent']['deb']['checksum']
    action :create_if_missing
    notifies :install, 'package[check-mk-agent]', :immediately
  end

  remote_file "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb" do
    source "#{node['check_mk']['url']}/check-mk-agent-logwatch_#{version}_all.deb"
    mode '0644'
    checksum node['check_mk']['logwatch']['deb']['checksum']
    action :create_if_missing
    notifies :install, 'package[check-mk-agent-logwatch]', :immediately
  end

  package 'check-mk-agent' do
    action :nothing
    source "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

  package 'check-mk-agent-logwatch' do
    action :nothing
    source "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

when 'rhel'
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + '-' + node['check_mk']['rpm']['release']

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm" do
    source "#{node['check_mk']['url']}/check_mk-agent-#{version}.noarch.rpm"
    mode '0644'
    checksum node['check_mk']['agent']['rpm']['checksum']
    action :create_if_missing
    notifies :install, 'package[check-mk-agent]', :immediately
  end

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm" do
    source "#{node['check_mk']['url']}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    mode '0644'
    checksum node['check_mk']['logwatch']['rpm']['checksum']
    action :create_if_missing
    notifies :install, 'package[check-mk-agent-logwatch]', :immediately
  end

  package 'check-mk-agent' do
    action :nothing
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end

  package 'check-mk-agent-logwatch' do
    action :nothing
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end
end

case node['os']
when 'linux'
  # runs /etc/init.d/xinetd (start|stop|restart), etc.
  service 'xinetd' do
    supports status => false, restart => true, reload => true
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

  %w(apache_status mk_jolokia mk_mysql mk_postgres mk_redis).each do |plugin|
    cookbook_file node['check_mk']['setup']['agentslibdir'] + '/plugins/' + plugin do
      source 'plugins/linux/' + plugin
      mode 0750
    end
  end

  template node['check_mk']['setup']['confdir'] + '/jolokia.cfg' do
    source 'check_mk/client/plugin_configs/jolokia.cfg.erb'
    owner 'root'
    group 'root'
    mode 0640
  end

when 'windows'
  windows_package "Check_MK Agent #{node['check_mk']['version']}" do
    source "#{node['check_mk']['url']}/check-mk-agent-#{node['check_mk']['version']}.exe"
    action :install
  end
  %w(ad_replication.bat).each do |plugin|
    cookbook_file 'C:\\Program Files (x86)\\check_mk\\plugins\\' + plugin do
      source 'plugins/windows/' + plugin
      mode 0750
    end
  end
end
