#
# Cookbook Name:: icinga
# Recipe:: _server_config
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute

# Setup various aspects of the Icinga Server
include_recipe "icinga::_server_config_icinga"
include_recipe "icinga::_server_config_pnp4nagios"
include_recipe "icinga::_server_config_check_mk"
include_recipe "icinga::_server_config_check_mk_propagate"