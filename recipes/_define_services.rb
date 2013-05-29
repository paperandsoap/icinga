#
# Cookbook Name:: icinga
# Recipe:: _define_services
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
# Used to properly address services once cmk is installed
#
execute 'reload-check-mk' do
  command 'check_mk -I ; check_mk -O'
  action :nothing
end

execute 'restart-check-mk' do
  command 'check_mk -II ; check_mk -R'
  action :nothing
end
