# Cookbook Name:: icinga
# Recipe:: master
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe "icinga::server"
include_recipe "icinga::client"

if ['debian', 'ubuntu'].member? node["platform"]

  if Chef::Config[:solo]
    nodes = search(:node, 'role:monitoring-server');
  else
    nodes = search(:node, 'role:monitoring-server');
  end

  # Multisite Configuration
  template "/etc/check_mk/multisite.d/sites.mk" do
    source "check_mk/master/sites.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
    variables(
        :nodes => nodes
    )
  end
end
