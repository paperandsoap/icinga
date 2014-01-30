# encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: _server_install_debian
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

if ['debian'].member? node['platform']
  # We need the backports repository for up-to-date Icinga version
  apt_repository "debmon-#{node['lsb']['codename']}" do
    key 'http://debmon.org/debmon/repo.key'
    uri 'http://debmon.org/debmon'
    distribution "debmon-#{node['lsb']['codename']}"
    components %w(main non-free)
    action :add
  end

  # Standard packages required by server
  %w(xinetd python php5-curl).each do |pkg|
    package pkg do
      action :install
    end
  end

  package 'icinga icinga-core icinga-cgi' do
    action :install
    options "-t debmon-#{node['lsb']['codename']}"
  end

  include_recipe 'rrdcached'
  include_recipe 'pnp4nagios'

  # Define all services
  %w(icinga xinetd).each do |svc|
    service svc do
      supports 'status' => true, 'restart' => true, 'reload' => true
      action :nothing
    end
  end
end
