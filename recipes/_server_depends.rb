#
# Cookbook Name:: icinga
# Recipe:: _server_depends
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute

# Needed to build check_mk from source (no debian package available)
include_recipe "build-essential"

# Install Apache2
include_recipe "apache2"

# Apache2 Modules
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_python"

# Enable default vhosts
apache_site "default-ssl"
apache_site "default"
