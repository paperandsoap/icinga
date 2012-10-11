#
# Cookbook Name:: icinga
# Recipe:: _server_install
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

if ['debian', 'ubuntu'].member? node[:platform]
  # Install the Icinga on Debian
  include_recipe "icinga::_server_install_debian"

  # Install Icinga Check_mk extension
  include_recipe "icinga::_server_install_check_mk_source"

  # Configure our server
  include_recipe "icinga::_server_config"
end