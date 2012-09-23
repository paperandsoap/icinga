# Cookbook Name:: icinga
# Recipe:: client
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

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

  package "xinetd" do
    action :install
  end

  # runs /etc/init.d/xinetd (start|stop|restart), etc.
  service "xinetd" do
    supports :status => true, :restart => true, :reload => true
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

  # Make sure it's installed. It would be a pretty broken system
  # that didn't have it.
  template "/etc/xinetd.d/check_mk" do
    source "check_mk/client/check_mk.erb"
    owner 'root'
    group 'root'
    mode 0640
    notifies :reload, resources(:service => "xinetd")
  end

end