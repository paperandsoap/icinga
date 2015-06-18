# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install_check_mk_source
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Version alias for check_mk
version = node['check_mk']['version']

# Source of check_mk
remote_file "#{Chef::Config[:file_cache_path]}/check_mk-#{version}.tar.gz" do
  source "#{node['check_mk']['url']}/check_mk-#{version}.tar.gz"
  mode '0644'
  checksum node['check_mk']['source']['tar']['checksum']
  action :create_if_missing
  notifies :create, 'template[/root/.check_mk_setup.conf]', :immediately
  notifies :run, 'bash[build_check_mk]', :immediately
end

# Add the setup template to compile check_mk
template '/root/.check_mk_setup.conf' do
  source 'check_mk/server/check_mk_setup.conf.erb'
  owner 'root'
  group 'root'
  mode 0640
  only_if { platform?('ubuntu', 'debian') }
  action :nothing
end

# We need to write some templates already here as setup.sh falls back if not exists
bash 'build_check_mk' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
    touch #{node['icinga']['htpasswd']['file']}
    tar -xzf check_mk-#{version}.tar.gz
    (cd check_mk-#{version} && ./setup.sh --yes)
    # Add #{node['apache']['group']} to Nagios group (Better in chef?)
    usermod -G nagios #{node['apache']['user']}
  EOF
  action :nothing
end

# As setup conf nagpipe is not used during setup (might be a bug) we need some workaround
directory '/var/log/nagios' do
  owner node['check_mk']['setup']['nagiosuser']
  group node['check_mk']['setup']['nagiosuser']
  mode 0755
  action :create
end

directory '/var/log/nagios/rw' do
  owner node['check_mk']['setup']['nagiosuser']
  group node['check_mk']['setup']['nagiosuser']
  mode 0755
  action :create
end

link '/var/log/nagios/rw/live' do
  to '/var/lib/icinga/rw/live'
  owner node['check_mk']['setup']['nagiosuser']
  group node['check_mk']['setup']['nagiosuser']
end
