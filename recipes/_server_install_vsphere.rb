# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install_vsphere
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

include_recipe 'python::pip'

python_pip 'pysphere'

# create graphios commands file
template '/etc/check_mk/conf.d/vsphere_hosts.mk'  do
  source 'check_mk/server/conf.d/vsphere_hosts.mk.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  variables('vsphere_hosts' => node['check_mk']['vsphere']['hosts'])
  notifies :run, 'execute[reload-check-mk]', :delayed
end unless node['check_mk']['vsphere']['hosts'].empty?
