# encoding: utf-8
# Cookbook Name:: icinga
# Recipe:: master
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

include_recipe 'icinga::server'
include_recipe 'icinga::client'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

if %w{ debian ubuntu }.member? node['platform']

  if Chef::Config[:solo]
    nodes = search(:node, 'role:monitoring-server')
  else
    nodes = search(:node, 'role:monitoring-server')
  end
  nodes.sort! { |a, b| a.name <=> b.name }

  # Multisite Configuration
  template '/etc/check_mk/multisite.d/sites.mk' do
    source 'check_mk/master/sites.mk.erb'
    owner 'nagios'
    group 'nagios'
    mode 0640
    variables(nodes: nodes)
  end

  # Proxy configuration
  template "#{node['apache']['dir']}/conf.d/multisite_proxy.conf" do
    source 'check_mk/master/multisite_proxy.conf.erb'
    owner 'nagios'
    group 'nagios'
    mode 0640
    variables(nodes: nodes)
    notifies :restart, 'service[apache2]', :delayed
  end
end
