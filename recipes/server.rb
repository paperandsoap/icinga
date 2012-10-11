#
# Cookbook Name:: icinga
# Recipe:: server
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# Install and configure the dependencies
include_recipe "icinga::_server_depends"

# Install Icinga and Check_mk
include_recipe "icinga::_server_install"

# Install the Icinga client recipe
include_recipe "icinga::client"
