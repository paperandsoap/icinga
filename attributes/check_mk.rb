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

# Check_mk settings
# Customizable search queries
default["check_mk"]["search"]["servers"] = "role:monitoring-server"
default["check_mk"]["search"]["nodes"] = "hostname:[* TO *] AND chef_environment:#{node.chef_environment}"

# Some defaults
default["check_mk"]["url"] = "http://mathias-kettner.de/download"
default["check_mk"]["version"] = '1.2.1i3'
default["check_mk"]["deb"]["release"] = '2'
default["check_mk"]["rpm"]["release"] = '1'
default["check_mk"]["agent"]["rpm"]["checksum"] = "70aa6f170cde31ada985b7f3892acd4a1c78ef99dc4b10f3a08944f7eaca5f9d"
default["check_mk"]["logwatch"]["rpm"]["checksum"] = "ffa67f28afd84702df44a95f4ee4699ef3afeb75f2b31d4f206af5f242952ba3"
default["check_mk"]["agent"]["deb"]["checksum"] = "357cac4a378ce92c74df55cdf8e4a23c9e2b80467a80de7a00fcf18c0df78ac5"
default["check_mk"]["logwatch"]["deb"]["checksum"] = "4633e3cad98584e2f2b2abb77e3d9247ded6f9d796408df19c75dfc03ac524e9"
default["check_mk"]["source"]["tar"]["checksum"] = "845b3bf16480d8e267b77e88cd1bd3c93b39d15bb0e534b62d12a4086e817045"
default["check_mk"]["groups"] = ["check-mk-admin"]
default["check_mk"]["setup"]["bindir"] = '/usr/bin'
default["check_mk"]["setup"]["confdir"] = '/etc/check_mk'
default["check_mk"]["setup"]["sharedir"] = '/usr/share/check_mk'
default["check_mk"]["setup"]["docdir"] = '/usr/share/doc/check_mk'
default["check_mk"]["setup"]["checkmandir"] = '/usr/share/doc/check_mk/checks'
default["check_mk"]["setup"]["vardir"] = '/var/lib/check_mk'
default["check_mk"]["setup"]["agentslibdir"] = '/usr/lib/check_mk_agent'
default["check_mk"]["setup"]["agentsconfdir"] = '/etc/check_mk'
default["check_mk"]["setup"]["nagiosuser"] = 'nagios'
default["check_mk"]["setup"]["wwwuser"] = 'www-data'
default["check_mk"]["setup"]["wwwgroup"] = 'nagios'
default["check_mk"]["setup"]["nagios_binary"] = '/usr/sbin/icinga'
default["check_mk"]["setup"]["nagios_config_file"] = '/etc/icinga/icinga.cfg'
default["check_mk"]["setup"]["nagconfdir"] = '/etc/icinga/objects'
default["check_mk"]["setup"]["nagios_startscript"] = '/etc/init.d/icinga'
default["check_mk"]["setup"]["nagpipe"] = '/var/lib/icinga/rw/icinga.cmd'
default["check_mk"]["setup"]["check_result_path"] = '/var/lib/icinga/spool/checkresults'
default["check_mk"]["setup"]["nagios_status_file"] = '/var/lib/icinga/status.dat'
default["check_mk"]["setup"]["check_icmp_path"] = '/usr/lib/nagios/plugins/check_icmp'
default["check_mk"]["setup"]["url_prefix"] = '/'
default["check_mk"]["setup"]["apache_config_dir"] = '/etc/apache2/conf.d'
default["check_mk"]["setup"]["nagios_auth_name"] = 'Icinga Access'
default["check_mk"]["setup"]["pnptemplates"] = '/usr/share/pnp4nagios/html/templates'
default["check_mk"]["setup"]["enable_livestatus"] = 'yes'
default["check_mk"]["setup"]["libdir"] = '/usr/lib/check_mk'
default["check_mk"]["setup"]["livesock"] = '/var/lib/icinga/rw/live'
default["check_mk"]["setup"]["livebackendsdir"] = '/usr/share/check_mk/livestatus'
default["check_mk"]["setup"]["multisite"]["config"]["file"] = "/etc/check_mk/multisite.mk"
default["check_mk"]["setup"]["multisite"]["config"]["nagvis_base_url"] = "/nagvis"
default["check_mk"]["module"]["file"] = "livestatus.o"
default["check_mk"]["legacy"]["checks"] = {
    "apache2" => {
        "name" => "check-http",
        "alias" => "Legacy_HTTP",
        "perfdata" => "True",
        "opts" => "-p 80"
    },
    "apache2::mod_ssl" => {
        "name" => "check-http",
        "alias" => "Legcay_HTTPs",
        "perfdata" => "True",
        "opts" => "-p 443 -S"
    },
    "jetty" => {
        "name" => "check-http",
        "alias" => "Legcay_Jetty",
        "perfdata" => "True",
        "opts" => "-p 8080"
    },
    "memcached" => {
        "name" => "check-tcp",
        "alias" => "Legcay_Memcached",
        "perfdata" => "True",
        "opts" => "-p 11211"
    }
}
default["check_mk"]["legacy"]["commands"] = {
    "check-http" => {
        "name" => "check-http",
        "line" => "$USER1$/check_http -I $HOSTADDRESS$ $ARG1$"
    },
    "check-tcp" => {
        "name" => "check-tcp",
        "line" => "$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$"
    }
}
