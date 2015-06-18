# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install_debian
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

case node.platform_family
when 'debian'
  # We need the backports repository for up-to-date Icinga version
  apt_repository "icinga-#{node['lsb']['codename']}" do
    key 'http://packages.icinga.org/icinga.key'
    uri "http://packages.icinga.org/#{node['platform']}/"
    distribution "icinga-#{node['lsb']['codename']}"
    components %w(main)
    action :add
  end
end

# Standard packages required by server
node['icinga']['setup']['package_dependencies'].each do |pkg|
  package pkg do
    action :install
  end
end

# since the upstream cookbook of apache2 is not doing it the apache2.2 way with
# the config folder, we have to override it
if node.platform? == 'debian' and node['platform_version'] <= 7
  begin
    r = resources(directory: "#{node['apache']['dir']}/conf.d")
    r.owner 'root'
    r.group 'root'
    r.mode '0755'
    r.action :nothing
  rescue Chef::Exceptions::ResourceNotFound
    Chef::Log.warn 'could not find resource to override!'
  end
end

package node['icinga']['setup']['packages'] do
  action :install
end

include_recipe 'rrdcached'
include_recipe 'pnp4nagios'

# Define all services
%w(icinga xinetd).each do |svc|
  service svc do
    supports 'status' => true, 'restart' => true, 'reload' => true
    action [:enable, :start]
  end
end
