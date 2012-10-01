# Cookbook Name:: bp-icinga
# Recipe:: master
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

include_recipe "bp-icinga::server"
include_recipe "bp-icinga::client"

if ['debian', 'ubuntu'].member? node[:platform]

  nodes = search(:node, 'role:monitoring-server');

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
