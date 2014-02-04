# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install_graphios
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

# create spool directory
directory node['check_mk']['graphios']['spool_directory'] do
  user node['icinga']['user']
  group node['icinga']['group']
  action :create
  recursive true
  mode 0755
end

# create log file
file node['check_mk']['graphios']['log_file'] do
  mode '640'
  owner node['icinga']['user']
  group node['icinga']['group']
end

# create graphios commands file
# rubocop:disable LineLength
template node['icinga']['setup']['config']['cfg_dir']['nagios_plugins'] + '/' + node['check_mk']['graphios']['commands_file'] do
# rubocop:enable LineLength
  source 'check_mk/server/graphios/graphios_commands.cfg.erb'
  owner 'root'
  group 'root'
  mode 0644
  action :create
end

# create mk files
template node['check_mk']['setup']['confdir'] + '/conf.d/extra_host_conf.mk' do
  source 'check_mk/server/graphios/extra_host_conf.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  action :create
end

template node['check_mk']['setup']['confdir'] + '/conf.d/extra_service_conf.mk' do
  source 'check_mk/server/graphios/extra_service_conf.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  action :create
end

# create graphios.py
template node['check_mk']['graphios']['graphios_bin_location'] + '/graphios.py' do
  source 'check_mk/server/graphios/graphios.py.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0740
  action :create
end

# create init script
template '/etc/init.d/graphios' do
  source 'check_mk/server/graphios/graphios.init.erb'
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

# graphios service
service 'graphios' do
# rubocop:disable HashSyntax
  supports :status => true
# rubocop:enable HashSyntax
  action [:enable, :start]
end
