# Cookbook Name:: icinga
# Recipe:: client
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# Include apt recipe to ensure system is updated prior to installing
include_recipe "apt"

# Install required packages based on platform
pkgs = value_for_platform_family(
    "rhel" => %w{ xinetd ethtool },
    "debian" => %w{ xinetd ethtool },
    "default" => %w{ xinetd ethtool }
)
pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

# runs /etc/init.d/xinetd (start|stop|restart), etc.
service "xinetd" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end

# Platform specific installation path  : Debian
if platform_family?("debian")
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + "-" + node['check_mk']['deb']['release']

  remote_file "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent_#{version}_all.deb"
    mode "0644"
    checksum node["check_mk"]["agent"]["deb"]["checksum"] # A SHA256 (or portion thereof) of the file.
    action :create_if_missing
    notifies :install, "package[check-mk-agent]", :immediately
  end

  remote_file "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent-logwatch_#{version}_all.deb"
    mode "0644"
    checksum node["check_mk"]["logwatch"]["deb"]["checksum"] # A SHA256 (or portion thereof) of the file.
    action :create_if_missing
    notifies :install, "package[check-mk-agent-logwatch]", :immediately
  end

  package "check-mk-agent" do
    action :nothing
    source "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

  package "check-mk-agent-logwatch" do
    action :nothing
    source "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end
end

# Platform specific installation path  : CentOS/RedHat/SuSE
if platform_family?("rhel")
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + "-" + node["check_mk"]["rpm"]["release"]

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm" do
    source "#{node["check_mk"]["url"]}/check_mk-agent-#{version}.noarch.rpm"
    mode "0644"
    checksum node["check_mk"]["agent"]["rpm"]["checksum"] # A SHA256 (or portion thereof) of the file.
    action :create_if_missing
    notifies :install, "package[check-mk-agent]", :immediately
  end

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm" do
    source "#{node["check_mk"]["url"]}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    mode "0644"
    checksum node["check_mk"]["logwatch"]["rpm"]["checksum"] # A SHA256 (or portion thereof) of the file.
    action :create_if_missing
    notifies :install, "package[check-mk-agent-logwatch]", :immediately
  end

  package "check-mk-agent" do
    action :nothing
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end

  package "check-mk-agent-logwatch" do
    action :nothing
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end
end

# Install all client plugins
if node["os"] == "linux"
  %w{ apache_status mk_jolokia mk_mysql mk_postgres }.each do |plugin|
    cookbook_file node["check_mk"]["setup"]["agentslibdir"] + "/plugins/" + plugin do
      source "plugins/linux/" + plugin
      mode 0750
    end
  end
  template node["check_mk"]["setup"]["confdir"] + "/jolokia.cfg" do
    source "check_mk/client/plugin_configs/jolokia.cfg.erb"
    owner 'root'
    group 'root'
    mode 0640
  end
elsif node["os"] == "windows"
  %w{ ad_replication.bat }.each do |plugin|
    cookbook_file "C:\\Program Files (x86)\\check_mk\\plugins\\" + plugin do
      source "plugins/windows/" + plugin
      mode 0750
    end
  end
end

# Reload xinetd if config changed
template "/etc/xinetd.d/check_mk" do
  source "check_mk/client/check_mk.erb"
  owner 'root'
  group 'root'
  mode 0640
  notifies :reload, resources(:service => "xinetd")
end
