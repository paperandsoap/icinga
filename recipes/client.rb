# Cookbook Name:: icinga
# Recipe:: client
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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
end


# Platform specific installation path  : Debian
if ['debian', 'ubuntu'].member? node[:platform]
  remote_file "/var/cache/apt/archives/check-mk-agent_1.2.0p2-2_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent_1.2.0p2-2_all.deb"
    mode "0644"
    checksum "556b9f83462458c7a718c954cabe71120954afaf8234c47be7e213bf01345f35" # A SHA256 (or portion thereof) of the file.
  end

  remote_file "/var/cache/apt/archives/check-mk-agent-logwatch_1.2.0p2-2_all.deb" do
    source "http://mathias-kettner.de/download/check-mk-agent-logwatch_1.2.0p2-2_all.deb"
    mode "0644"
    checksum "c788532be5af7a93d89a040d0e66539787e528a6e84e15bcca82cc12dd80b884" # A SHA256 (or portion thereof) of the file.
  end


  package "check-mk-agent" do
    action :install
    source "/var/cache/apt/archives/check-mk-agent_1.2.0p2-2_all.deb"
    provider Chef::Provider::Package::Dpkg
  end

  package "check-mk-agent-logwatch" do
    action :install
    source "/var/cache/apt/archives/check-mk-agent-logwatch_1.2.0p2-2_all.deb"
    provider Chef::Provider::Package::Dpkg
  end
end

# Platform specific installation path  : CentOS/RedHat/SuSE
if ['centos', 'redhat', 'suse', 'fedora'].member? node[:platform]
  remote_file "#{Chef::Config[:file_cache_path]}/check-mk-agent_1.2.0p2-2_all.deb" do
    source "http://mathias-kettner.de/download/check_mk-agent-1.2.0p2-1.noarch.rpm"
    mode "0644"
    checksum "ce17f7d9bdc51339a9595c84a3636aad4bfee54c8a4cd36eb32923ec2e21e187" # A SHA256 (or portion thereof) of the file.
  end

  remote_file "#{Chef::Config[:file_cache_path]}/check-mk-agent-logwatch_1.2.0p2-2_all.deb" do
    source "http://mathias-kettner.de/download/check_mk-agent-logwatch-1.2.0p2-1.noarch.rpm"
    mode "0644"
    checksum "cb179d1c5b41bce3d4d89ed14dffbdc4fb3de2c1a1ca94626af8200ce88c5d4c" # A SHA256 (or portion thereof) of the file.
  end


  package "check-mk-agent" do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check-mk-agent_1.2.0p2-2_all.rpm"
    provider Chef::Provider::Package::Rpm
  end

  package "check-mk-agent-logwatch" do
    action :install
    source "#{Chef::Config[:file_cache_path]}/check-mk-agent-logwatch_1.2.0p2-2_all.deb"
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