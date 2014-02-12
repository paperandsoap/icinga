# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_config_chec_mk_propagate
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

include_recipe 'icinga::_define_services'

if Chef::Config[:solo]
  # Find nodes in our environment
  nodes = search(:node, node['check_mk']['search']['nodes'])
else
  nodes = search(:node, node['check_mk']['search']['nodes'])
end
nodes.sort! { |a, b| a.name <=> b.name }

# If no nodes are found only add ourselves
if nodes.empty?
  Chef::Log.info('Not able to find any nodes in this environment.')
  nodes = []
  nodes << node
end

# Search for all roles and environments to create hostgroups to use as check_mk tags
roles = search(:role, 'name:*')
roles.sort! { |a, b| a.name <=> b.name }

if Chef::Config[:solo]
  environments = ['_default']
else
  environments = search(:environment, 'name:*')
end

# Search all nodes for tags and os and add them to check_mk tagging and hostgroups
tags = []
os_list = []
metadata_pids = []
metadata_unixnames = []

nodes.each do |client_node|
  if node['check_mk']['metadata']['enabled']
    client_node.normal['metadata_pids'] = []
    client_node.normal['metadata_unixnames'] = []
    metadata_name = client_node['check_mk']['metadata']['name']
    
    client_node[metadata_name]['meta.pids'].each do |pid|
      metadata_pids.push(pid)
      client_node.normal['metadata_pids'].push(pid)
    end unless client_node[metadata_name]['meta.pids'].nil?
    client_node[metadata_name]['meta.unixnames'].each do |unixname|
      metadata_unixnames.push(unixname)
      client_node.normal['metadata_unixnames'].push(unixname)
    end unless client_node[metadata_name]['meta.unixnames'].nil?
  end
  client_node['tags'].each do |tag|
    tags.push(tag)
  end
  os_list.push(client_node['os'])
end
os_list.sort.uniq
tags.sort.uniq
metadata_pids.sort.uniq
metadata_unixnames.sort.uniq

# manual hosts
manual_hosts = []
node['check_mk']['manual_checks']['hosts'].each do |host|
  manual_hosts.push(host)
end unless node['check_mk']['manual_checks']['hosts'].nil?

# manual checks
manual_checks = []
node['check_mk']['manual_checks']['checks'].each do |check|
  manual_checks.push(check)
end unless node['check_mk']['manual_checks']['checks'].nil?

template '/etc/check_mk/conf.d/manual_checks.mk' do
  source 'check_mk/server/conf.d/manual_checks.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  variables('manual_checks' => manual_checks)
  notifies :run, 'execute[reload-check-mk]', :delayed
end

# Add all defined legacy cehcks
template '/etc/check_mk/conf.d/legacy-checks.mk' do
  source 'check_mk/server/conf.d/legacy-checks.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  variables('nodes' => nodes)
  notifies :run, 'execute[reload-check-mk]', :delayed
end

# Add all found nodes to this server
template '/etc/check_mk/conf.d/wato/hosts.mk' do
  source 'check_mk/server/conf.d/monitoring-nodes.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  variables('nodes' => nodes, 'manual_nodes' => manual_hosts)
  notifies :run, 'execute[reload-check-mk]', :delayed
end

# Add all roles as hostgroups as they are used as tags for nodes
template "/etc/check_mk/conf.d/hostgroups-#{node['hostname']}.mk" do
  source 'check_mk/server/conf.d/hostgroups.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  variables(
      'roles' => roles,
      'environments' => environments,
      'tags' => tags,
      'os_list' => os_list,
      'metadata_pids' => metadata_pids,
      'metadata_unixnames' => metadata_unixnames
  )
  notifies :run, 'execute[reload-check-mk]', :delayed
end

template '/etc/check_mk/conf.d/wato/rules.mk' do
  source 'check_mk/server/conf.d/rules.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  notifies :run, 'execute[restart-check-mk]', :delayed
end

template '/usr/share/check_mk/notifications/sms.php' do
  source 'check_mk/server/notifications/sms.php.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0770
end
