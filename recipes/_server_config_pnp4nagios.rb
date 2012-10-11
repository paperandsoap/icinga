#
# Cookbook Name:: icinga
# Recipe:: _server_config_pnp4nagios
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# pnp4nagios templates
template "/etc/apache2/conf.d/pnp4nagios.conf" do
  source "pnp4nagios/pnp4nagios.conf.erb"
  owner 'root'
  group 'root'
  mode 0640
  notifies :reload, resources(:service => "apache2")
end
template "/etc/pnp4nagios/apache.conf" do
  source "pnp4nagios/pnp4nagios.conf.erb"
  owner 'root'
  group 'root'
  mode 0640
end
template "/etc/default/npcd" do
  source "pnp4nagios/npcd.erb"
  owner 'root'
  group 'root'
  mode 0640
  notifies :restart, resources(:service => "npcd")
end
template "/etc/pnp4nagios/process_perfdata.cfg" do
  source "pnp4nagios/process_perfdata.cfg.erb"
  owner 'root'
  group 'root'
  mode 0644
end
template "/etc/default/rrdcached" do
  source "rrdcached/rrdcached.erb"
  owner 'root'
  group 'root'
  mode 0640
  notifies :restart, resources(:service => "rrdcached")
end
template "/etc/pnp4nagios/config.php" do
  source "pnp4nagios/pnp4nagios_config.php.erb"
  owner 'root'
  group node['apache']['user']
  mode 0640
end