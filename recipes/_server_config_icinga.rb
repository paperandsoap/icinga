#
# Cookbook Name:: icinga
# Recipe:: _server_config_icinga
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute

# Icinga Configuration
template "/etc/icinga/icinga.cfg" do
  source "icinga/icinga.cfg.erb"
  owner node["icinga"]["user"]
  group node["icinga"]["group"]
  mode 0640
  notifies :restart, resources(:service => "icinga")
end

# Remove some default files
%w{ /etc/icinga/objects/extinfo_icinga.cfg /etc/icinga/objects/hostgroups_icinga.cfg /etc/icinga/objects/localhost_icinga.cfg /etc/icinga/objects/services_icinga.cfg }.each do |f|
  file f do
    action :delete
  end
end

# Needs suid to run as root from by nagios
file "/usr/lib64/nagios/plugins/check_icmp" do
  mode "4750"
  owner "root"
  group node["icinga"]["group"]
end

file "/etc/icinga/htpasswd.users" do
  mode "640"
  owner node['apache']['user']
  group node["icinga"]["group"]
end

# Change some permissions
%w{ /var/lib/icinga/rw /etc/icinga }.each do |d|
  file d do
    owner node["icinga"]["user"]
    group node['apache']['user']
    mode "770"
  end
end