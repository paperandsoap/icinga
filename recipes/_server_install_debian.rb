#
# Cookbook Name:: icinga
# Recipe:: _server_install_debian
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

if ['debian'].member? node["platform"]
# We need the backports repository for up-to-date Icinga version
  apt_repository node["lsb"]["codename"] + "-backports" do
    uri "http://backports.debian.org/debian-backports"
    distribution node["lsb"]["codename"] + "-backports"
    components ["main", "non-free"]
    action :add
  end

# TODO: The install process is a bit messy (hard-coded versions)since debian-backports is not used when finding installation candidates
# Standard packages required by server
  pkgs = value_for_platform(
      "default" => %w{ xinetd python }
  )
  pkgs.each do |pkg|
    package pkg do
      action :install
    end
  end

  package "rrdcached" do
    version node["rrdcached"]["version"]
    action :install
    options "-t " + node["lsb"]["codename"] + "-backports"
  end
  pkgsbackports = value_for_platform(
      ["debian", "ubuntu"] =>
          {"default" => %w{ icinga icinga-cgi icinga-core icinga-doc }}
  )
  %w{ icinga icinga-cgi icinga-core icinga-doc }.each do |pkg|
    package pkg do
      version node["icinga"]["version"]
      action :install
      options "-t " + node["lsb"]["codename"] + "-backports"
    end
  end

# Install pnp4nagios now to avoid Nagios3 dependency
  package "pnp4nagios" do
    version node["pnp4nagios"]["version"]
    action :install
    options "-t " + node["lsb"]["codename"] + "-backports"
  end

# Define all services
  %w{ icinga npcd xinetd rrdcached }.each do |svc|
    service svc do
      supports :status => true, :restart => true, :reload => true
      action [:enable, :start]
    end
  end
end
