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

# rrdcached
default["rrdcached"]["config"]["socket"] = "unix:/var/run/rrdcached.sock"
default["rrdcached"]["version"] = "1.4.3-1"
default["rrdcached"]["setup"]["config"]["write_time"] = "1800"
default["rrdcached"]["setup"]["config"]["write_delay"] = "1800"
default["rrdcached"]["setup"]["config"]["socket_group"] = "nagios"
default["rrdcached"]["setup"]["config"]["rrdcached"]["DISABLE"] = "0"
default["rrdcached"]["setup"]["config"]["rrdcached"]["MAXWAIT"] = "30"
default["rrdcached"]["setup"]["config"]["rrdcached"]["ENABLE_COREFILES"] = "0"
