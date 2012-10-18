#
# Cookbook Name:: icinga
# Recipe:: _server_config_chec_mk_propagate
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute


# Command definition to reload check_mk when template changed
execute "reload-check-mk" do
  command "check_mk -I ; check_mk -O"
  action :nothing
end

# Find nodes in our environment
nodes = search(:node, "hostname:[* TO *] AND chef_environment:#{node.chef_environment}")

# If no nodes are found only add ourselves
if nodes.empty?
  Chef::Log.info("Not able to find any nodes in this environment.")
  nodes = Array.new
  nodes << node
end

# Search for all roles and environments to create hostgroups to use as check_mk tags
roles = search(:role, 'name:*');
environments = search(:environment, 'name:*')

# Search all nodes for tags and os and add them to check_mk tagging and hostgroups
tags = Array.new
os_list = Array.new
nodes.each do |client_node|
  client_node['tags'].each do |tag|
    tags.push(tag)
  end
  os_list.push(client_node['os'])
end
os_list.uniq
tags.uniq

# Add all found nodes to this server
template "/etc/check_mk/conf.d/monitoring-nodes-#{node['hostname']}.mk" do
  source "check_mk/server/client_nodes.mk.erb"
  owner node["icinga"]["user"]
  group node["icinga"]["group"]
  mode 0640
  variables(
      :nodes => nodes
  )
  notifies :run, "execute[reload-check-mk]"
end

# Add all roles as hostgroups as they are used as tags for nodes
template "/etc/check_mk/conf.d/hostgroups-#{node['hostname']}.mk" do
  source "check_mk/server/hostgroups.mk.erb"
  owner node["icinga"]["user"]
  group node["icinga"]["group"]
  mode 0640
  variables(
      :roles => roles,
      :environments => environments,
      :tags => tags,
      :os_list => os_list
  )
  notifies :run, "execute[reload-check-mk]"
end