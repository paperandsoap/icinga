#
# Cookbook Name:: icinga
# Recipe:: _server_config_check_mk
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

include_recipe 'icinga::_define_services'

# Change some permissions
file '/etc/check_mk/conf.d/distributed_wato.mk' do
  mode '640'
  owner node['apache']['user']
  group node['icinga']['group']
end
%w(/etc/check_mk/conf.d /etc/check_mk/conf.d/wato /etc/check_mk/conf.d /etc/check_mk/multisite.d /etc/check_mk/multisite.d/wato).each do |d|
  directory d do
    owner node['icinga']['user']
    group node['apache']['user']
    mode '770'
  end
end

directory '/var/lib/check_mk/notify' do
  user 'root'
  group node['icinga']['group']
  mode 0775
end

# Multisite Configuration
template '/etc/check_mk/multisite.mk' do
  source 'check_mk/server/multisite.d/multisite.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
end
template '/etc/check_mk/multisite.d/wato-configuration.mk' do
  source 'check_mk/server/multisite.d/wato-configuration.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
end
template '/etc/check_mk/multisite.d/business-intelligence.mk' do
  source 'check_mk/server/multisite.d/business-intelligence.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
end

# check_mk livestatus xinetd template
template '/etc/xinetd.d/livestatus' do
  source 'check_mk/server/xinetd/livestatus.erb'
  owner 'root'
  group 'root'
  mode 0640
  notifies :reload, 'service[xinetd]'
end

users = []
# get group from databag
node['check_mk']['groups'].each do |groupid|
  # get the group data bag
  group = data_bag_item('groups', groupid)
  # for every member
  group[node.chef_environment]['members'].each do |userid|
    users.push(data_bag_item('users', userid))
  end
end

users = users.sort

# Ensure all users run the default sidebar, do not overwrite if it exists already
users.each do |user|
  directory node['check_mk']['setup']['vardir'] + '/web/' + user['id'] do
    owner node['apache']['user']
    group 'root'
    mode '0750'
    action :create
  end
  template node['check_mk']['setup']['vardir'] + '/web/' + user['id'] + '/sidebar.mk' do
    source 'check_mk/server/user/sidebar.mk.erb'
    owner node['apache']['user']
    group 'root'
    mode 0640
    action :create_if_missing
  end
end

# Write the htaccess file for check_mk users
template node['icinga']['htpasswd']['file'] do
  source 'icinga/htpasswd.users.erb'
  owner 'root'
  group node['apache']['user']
  mode '660'
  variables(:users => users)
end

# Create timeperiods, needs to be done before contacts
template '/etc/check_mk/conf.d/wato/timeperiods.mk' do
  source 'check_mk/server/conf.d/timeperiods.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  notifies :run, 'execute[restart-check-mk]', :delayed
end

# Create contacts for proper notifications if enabled
template '/etc/check_mk/conf.d/wato/contacts.mk' do
  source 'check_mk/server/conf.d/contacts.mk.erb'
  owner 'root'
  group node['apache']['group']
  mode '664'
  variables(:users => users)
  notifies :run, 'execute[restart-check-mk]', :delayed
end

# Ensure these users also have multisite access
template '/etc/check_mk/multisite.d/wato/users.mk' do
  source 'check_mk/server/multisite.d/users.mk.erb'
  owner 'root'
  group node['apache']['group']
  mode '664'
  variables(:users => users)
end

# Global configuration settings
template '/etc/check_mk/conf.d/global-configuration.mk' do
  source 'check_mk/server/conf.d/global-configuration.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  notifies :run, 'execute[reload-check-mk]', :delayed
end

# Simple configuration
node['check_mk']['config'].sort.each do |config, data|
  template '/etc/check_mk/conf.d/' + config + '.mk' do
    source 'check_mk/server/conf.d/simple-config.mk.erb'
    owner node['icinga']['user']
    group node['icinga']['group']
    mode 0640
    notifies :run, 'execute[reload-check-mk]', :delayed
    variables('variable' => config)
    not_if node['check_mk']['config'].nil?
  end
end

# Additional service checks
%w( redis ).each do |check|
  cookbook_file node['check_mk']['setup']['sharedir'] + '/checks/' + check do
    source 'checks/' + check
    mode 0644
  end
end
