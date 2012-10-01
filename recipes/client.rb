# Cookbook Name:: icinga
# Recipe:: client
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# Include apt recipe to ensure system is updated prior to installing
include_rcipe "apt"

# Install required packages based on platform
pkgs = value_for_platform(
    ["centos", "redhat", "suse", "fedora"] => {
        "default" => %w{ xinetd ethtool }
    },
    ["ubuntu", "debian"] => {
        "default" => %w{ xinetd ethtool }
    },
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
  action [ :enable, :start ]
end

# Platform specific installation path  : Debian
if ['debian', 'ubuntu'].member? node[:platform]
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + "-" + node['check_mk']['deb']['release']

  remote_file "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent_#{version}_all.deb"
    mode "0644"
    checksum node["check_mk"]["agent"]["deb"]["checksum"] # A SHA256 (or portion thereof) of the file.
  end

  remote_file "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent-logwatch_#{version}_all.deb"
    mode "0644"
    checksum node["check_mk"]["logwatch"]["deb"]["checksum"] # A SHA256 (or portion thereof) of the file.
  end

  package "check-mk-agent" do
    action :install
    source "/var/cache/apt/archives/check-mk-agent_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

  package "check-mk-agent-logwatch" do
    action :install
    source "/var/cache/apt/archives/check-mk-agent-logwatch_#{version}_all.deb"
    provider Chef::Provider::Package::Dpkg
  end
end

# Platform specific installation path  : CentOS/RedHat/SuSE
if ['centos', 'redhat', 'suse', 'fedora'].member? node[:platform]
  # Create our version string to fetch the appropriate file
  version = node['check_mk']['version'] + "-" + node['check_mk']['rpm']['release']

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm" do
    source "#{node["check_mk"]["url"]}/check_mk-agent-#{version}.noarch.rpm"
    mode "0644"
    checksum node["check_mk"]["agent"]["rpm"]["checksum"] # A SHA256 (or portion thereof) of the file.
  end

  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm" do
    source "#{node["check_mk"]["url"]}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    mode "0644"
    checksum node["check_mk"]["logwatch"]["rpm"]["checksum"] # A SHA256 (or portion thereof) of the file.
  end

  package "check-mk-agent" do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end

  package "check-mk-agent-logwatch" do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check_mk-agent-logwatch-#{version}.noarch.rpm"
    provider Chef::Provider::Package::Rpm
  end
end

# Ensure service is enabled
template "/etc/xinetd.d/check_mk" do
  source "check_mk/client/check_mk.erb"
  owner 'root'
  group 'root'
  mode 0640
  notifies :reload, resources(:service => "xinetd")
end
