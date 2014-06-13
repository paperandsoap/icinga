# encoding: utf-8
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

# Check_mk settings
# Customizable search queries
default['check_mk']['search']['servers'] = 'role:monitoring-server'
default['check_mk']['search']['nodes'] = "hostname:[* TO *] AND chef_environment:#{node.chef_environment}"

# Master or slave?
default['check_mk']['isMaster'] = 'False'

# Custom configurations
default['check_mk']['config'] = nil

# Metadata parsing
default['check_mk']['metadata']['enabled'] = false
default['check_mk']['metadata']['name'] = 'mycompany'

# Manual hosts & checks
default['check_mk']['manual_checks']['hosts'] = []
default['check_mk']['manual_checks']['checks'] = []

# Enable vsphere monitoring?
default['check_mk']['vsphere']['enabled'] = false
default['check_mk']['vsphere']['user'] = 'user'
default['check_mk']['vsphere']['password'] = 'password'
default['check_mk']['vsphere']['modules'] = 'hostsystem,virtualmachine,datastore,counters'
default['check_mk']['vsphere']['hosts'] = []

# Enable graphios (perfdata to graphite)?
default['check_mk']['graphios']['enabled'] = false
default['check_mk']['graphios']['graphite_prefix'] = 'check_mk'
default['check_mk']['graphios']['checks_to_pass'] = [
  { graphite_folder: 'check_mk', command: 'Check_MK' },
  { graphite_folder: 'cpu.load', command: 'CPU load' }
]
default['check_mk']['graphios']['commands_file'] = 'graphios_commands.cfg'
default['check_mk']['graphios']['carbon_server'] = '127.0.0.1'
default['check_mk']['graphios']['carbon_port'] = 2004
default['check_mk']['graphios']['spool_directory'] = '/var/spool/nagios/graphios'
default['check_mk']['graphios']['graphios_bin_location'] = '/var/lib/icinga'
default['check_mk']['graphios']['log_file'] = '/var/log/icinga/graphios.log'
default['check_mk']['graphios']['log_max_size'] = 25165824
default['check_mk']['graphios']['log_level'] = 'logging.INFO'
default['check_mk']['graphios']['sleep_time'] = 15
default['check_mk']['graphios']['sleep_max'] = 480
default['check_mk']['graphios']['test_mode'] = 'False'

# Some defaults
default['check_mk']['snmp']['public_community'] = 'public'
default['check_mk']['snmp']['auto_discovery'] = 'False'
default['check_mk']['wato']['enabled'] = 'False'
default['check_mk']['notifications']['enabled'] = 'False'
default['check_mk']['notifications']['nawom']['url'] = 'https://nawom.bigpoint.net'
default['check_mk']['notifications']['nawom']['api_version'] = 'v1'
default['check_mk']['notifications']['sms']['user'] = 'SMSUSER'
default['check_mk']['notifications']['sms']['password'] = 'SMSPASSWORD'
default['check_mk']['notifications']['sms']['gatewayUrl'] = 'http://gateway.smskaufen.de/?id=%SMSUSER%&pw=%SMSPASSWORD%&empfaenger=%RECIPIENT%&absender=%SENDER%&type=4&text=%CONTENT%'
default['check_mk']['url'] = 'http://mathias-kettner.de/download'
default['check_mk']['version'] = '1.2.4p1'
default['check_mk']['deb']['release'] = '2'
default['check_mk']['rpm']['release'] = '1'
default['check_mk']['agent']['rpm']['checksum'] = 'c7ef48d11c4dc7d88478bd7acac49b662d95a8b76b28455ab196ee00b7026f19'
default['check_mk']['agent']['deb']['checksum'] = '89defe8618599a1ca1b5edbdf6c9561959519c61e61cdc60079697c9a3ad448f'
default['check_mk']['agent']['exe']['checksum'] = '18a9b460858dc710c4735447557e1d57625907df9f83fb921a2fde3fae119064'
default['check_mk']['logwatch']['rpm']['checksum'] = '4eda8341b967d9555e1bbafbd24c70ce3343c567bd2029bdd6d3eab3c32b2697'
default['check_mk']['logwatch']['deb']['checksum'] = '84df38cc723c2e4e8fa5ae39be08e3afc48c739b575cc2c833976531e3c1f420'
default['check_mk']['source']['tar']['checksum'] = 'dac5c231e557a305646074f51f0259af8b22edc2ef77224a41a310bea51e4f07'
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
default['check_mk']['filesystem']['default_levels']['warning'] = 90.0
default['check_mk']['filesystem']['default_levels']['critical'] = 95.0
