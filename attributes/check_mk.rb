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

# Check_mk settings
# Customizable search queries
default['check_mk']['search']['servers'] = 'role:monitoring-server'
default['check_mk']['search']['nodes'] = "hostname:[* TO *] AND chef_environment:#{node.chef_environment}"

# Some defaults
default['check_mk']['config']['ignored_services'] = [
    'ALL_HOSTS, [ "Monitoring" ]',
    'ALL_HOSTS, [ "NFS mount /var/userhome/.*" ]',
    'ALL_HOSTS, [ "IPMI Sensor Fan_Fan4" ]',
    'ALL_HOSTS, [ "IPMI Sensor Fan_Fan5" ]',
    'ALL_HOSTS, [ "IPMI Sensor Fan_Fan6" ]',
    'ALL_HOSTS, [ "IPMI Sensor Fan_Fan7/CPU1" ]',
    'ALL_HOSTS, [ "IPMI Sensor Fan_Fan8/CPU2" ]',
    '["switch"], ALL_HOSTS, ["Interface\s\d+"]',
    '["router"], ALL_HOSTS, ["Interface\s\d+"]',
]
default['check_mk']['config']['ignored_checks'] = [
    '[ "mysql_capacity" ], ALL_HOSTS'
]
default['check_mk']['wato']['enabled'] = 'False'
default['check_mk']['notifications']['email']['disabled'] = 'False'
default['check_mk']['notifications']['sms']['disabled'] = 'False'
default['check_mk']['notifications']['sms']['user'] = 'SMSUSER'
default['check_mk']['notifications']['sms']['password'] = 'SMSPASSWORD'
default['check_mk']['notifications']['sms']['gatewayUrl'] = 'http://gateway.smskaufen.de/?id=%SMSUSER%&pw=%SMSPASSWORD%&empfaenger=%RECIPIENT%&absender=%SENDER%&type=4&text=%CONTENT%'
default['check_mk']['url'] = 'http://mathias-kettner.de/download'
default['check_mk']['version'] = '1.2.2p2'
default['check_mk']['deb']['release'] = '2'
default['check_mk']['rpm']['release'] = '1'
default['check_mk']['agent']['rpm']['checksum'] = '03a163625043caa4d4208bd2e54a9402faf74a8a704a8ee43524af74b34c99fe'
default['check_mk']['agent']['deb']['checksum'] = '40af3f35e541de1b55fa4122e8382e967ab56dfa438cf096377ffdd011649ef4'
default['check_mk']['agent']['exe']['checksum'] = '44bb2ebddc750e5f2c6bfda2e9a9a67ae0e8a18b07fa386168005e8173739056'
default['check_mk']['logwatch']['rpm']['checksum'] = 'f9f644d72f0d190c60b1bf445176fc68d92dad6722c97e01ea288f4905517aeb'
default['check_mk']['logwatch']['deb']['checksum'] = '8b6a9fb056b3ac99b09e691bd77b849b715c033eb30f0984e0c0cf1e1945ff7e'
default['check_mk']['source']['tar']['checksum'] = '3ef638c0de39b015e02e7d60c0d612c0fcf516a7e4766ab836dc205d7330b15f'
default['check_mk']['groups'] = ['check-mk-admin']
default['check_mk']['setup']['bindir'] = '/usr/bin'
default['check_mk']['setup']['confdir'] = '/etc/check_mk'
default['check_mk']['setup']['sharedir'] = '/usr/share/check_mk'
default['check_mk']['setup']['docdir'] = '/usr/share/doc/check_mk'
default['check_mk']['setup']['checkmandir'] = '/usr/share/doc/check_mk/checks'
default['check_mk']['setup']['vardir'] = '/var/lib/check_mk'
default['check_mk']['setup']['agentslibdir'] = '/usr/lib/check_mk_agent'
default['check_mk']['setup']['agentsconfdir'] = '/etc/check_mk'
default['check_mk']['setup']['nagiosuser'] = 'nagios'
default['check_mk']['setup']['wwwuser'] = 'www-data'
default['check_mk']['setup']['wwwgroup'] = 'nagios'
default['check_mk']['setup']['nagios_binary'] = '/usr/sbin/icinga'
default['check_mk']['setup']['nagios_config_file'] = '/etc/icinga/icinga.cfg'
default['check_mk']['setup']['nagconfdir'] = '/etc/icinga/objects'
default['check_mk']['setup']['nagios_startscript'] = '/etc/init.d/icinga'
default['check_mk']['setup']['nagpipe'] = '/var/lib/icinga/rw/icinga.cmd'
default['check_mk']['setup']['check_result_path'] = '/var/lib/icinga/spool/checkresults'
default['check_mk']['setup']['nagios_status_file'] = '/var/lib/icinga/status.dat'
default['check_mk']['setup']['check_icmp_path'] = '/usr/lib/nagios/plugins/check_icmp'
default['check_mk']['setup']['url_prefix'] = '/'
default['check_mk']['setup']['apache_config_dir'] = '/etc/apache2/conf.d'
default['check_mk']['setup']['nagios_auth_name'] = 'Restricted Access'
default['check_mk']['setup']['pnptemplates'] = '/usr/share/pnp4nagios/html/templates'
default['check_mk']['setup']['enable_livestatus'] = 'yes'
default['check_mk']['setup']['libdir'] = '/usr/lib/check_mk'
default['check_mk']['setup']['livesock'] = '/var/lib/icinga/rw/live'
default['check_mk']['setup']['livebackendsdir'] = '/usr/share/check_mk/livestatus'
default['check_mk']['setup']['multisite']['config']['file'] = '/etc/check_mk/multisite.mk'
default['check_mk']['setup']['multisite']['config']['nagvis_base_url'] = '/nagvis'
default['check_mk']['module']['file'] = 'livestatus.o'
default['check_mk']['legacy']['checks'] = {
    'apache2' => {
        'name' => 'check-http',
        'alias' => 'Legacy_HTTP',
        'perfdata' => 'True',
        'opts' => '-p 80'
    },
    'apache2::mod_ssl' => {
        'name' => 'check-http',
        'alias' => 'Legacy_HTTPs',
        'perfdata' => 'True',
        'opts' => '-p 443 -S'
    },
    'jetty' => {
        'name' => 'check-http',
        'alias' => 'Legacy_Jetty',
        'perfdata' => 'True',
        'opts' => '-p 8080 -u /status/'
    },
    'memcached' => {
        'name' => 'check-tcp',
        'alias' => 'Legacy_Memcached',
        'perfdata' => 'True',
        'opts' => '-p 11211'
    }
}
default['check_mk']['legacy']['commands'] = {
    'check-http' => {
        'name' => 'check-http',
        'line' => '$USER1$/check_http -I $HOSTADDRESS$ $ARG1$'
    },
    'check-tcp' => {
        'name' => 'check-tcp',
        'line' => '$USER1$/check_tcp -H $HOSTADDRESS$ $ARG1$'
    }
}
