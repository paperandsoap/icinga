# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install
#
# Copyright 2012, BigPoint GmbH
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
#

#if ['debian'].member? node['platform']
  # Install the Icinga on Debian
  include_recipe 'icinga::_server_install_packages'

  # Install Icinga Check_mk extension
  include_recipe 'icinga::_server_install_check_mk_source'

  # Configure our server
  include_recipe 'icinga::_server_config'

  # Install graphios if enabled
  include_recipe 'icinga::_server_install_graphios' if node['check_mk']['graphios']['enabled']

  # Install vsphere monitoring if enabled
  include_recipe 'icinga::_server_install_vsphere' if node['check_mk']['vsphere']['enabled']
#end
