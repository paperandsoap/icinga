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
default['check_mk']['deb']['release'] = '1'
default['check_mk']['rpm']['release'] = '1'
default['check_mk']['agent']['rpm']['checksum'] = '0740fcd529de1f3c92dc7b28919c410c60bfab39ab54cb03561f190966f843a0'
default['check_mk']['agent']['deb']['checksum'] = 'c7ef48d11c4dc7d88478bd7acac49b662d95a8b76b28455ab196ee00b7026f19'
default['check_mk']['agent']['exe']['checksum'] = 'a82438b5e69b2276ca278000b66198f736894b5b626fd9959073edc263ae5108'
default['check_mk']['logwatch']['rpm']['checksum'] = '9abdc5da0f7b7e0e3b062b738d02c0660c9485ed6acde8ded2083bed0e8f1432'
default['check_mk']['logwatch']['deb']['checksum'] = '6e10496faafdb3719c76b404c8e522ea92a6d3be6cb29f5c0b49afb334b5d265'
default['check_mk']['source']['tar']['checksum'] = '78487129e244c853551bd3211639583d695cc44ee960856df7610d0c4dce8b31'
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
