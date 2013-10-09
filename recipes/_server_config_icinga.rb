#
# Cookbook Name:: icinga
# Recipe:: _server_config_icinga
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

# Icinga Configuration
template '/etc/icinga/icinga.cfg' do
  source 'icinga/icinga.cfg.erb'
  owner node['icinga']['user']
  group node['icinga']['group']
  mode 0640
  notifies :restart, 'service[icinga]'
end

# Remove some default files
%w(/etc/icinga/objects/extinfo_icinga.cfg
   /etc/icinga/objects/hostgroups_icinga.cfg
   /etc/icinga/objects/localhost_icinga.cfg
   /etc/icinga/objects/services_icinga.cfg
  ).each do |f|
  file f do
    action :delete
  end
end

# symlink /usr/lib/ as /usr/lib64/
link "/usr/lib64" do
  to "/usr/lib"
end

# Needs suid to run as root from by nagios
file '/usr/lib64/nagios/plugins/check_icmp' do
  mode '4750'
  owner 'root'
  group node['icinga']['group']
end

file '/etc/icinga/htpasswd.users' do
  mode '640'
  owner node['apache']['user']
  group node['icinga']['group']
end

# Change some permissions
%w(/var/lib/icinga/rw /etc/icinga).each do |d|
  directory d do
    owner node['icinga']['user']
    group node['apache']['user']
    mode '770'
  end
end
