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
default['check_mk']['wato']['enabled'] = 'False'
default['check_mk']['notifications']['enabled'] = 'False'
default['check_mk']['notifications']['sms']['user'] = 'SMSUSER'
default['check_mk']['notifications']['sms']['password'] = 'SMSPASSWORD'
default['check_mk']['notifications']['sms']['gatewayUrl'] = 'http://gateway.smskaufen.de/?id=%SMSUSER%&pw=%SMSPASSWORD%&empfaenger=%RECIPIENT%&absender=%SENDER%&type=4&text=%CONTENT%'
default['check_mk']['url'] = 'http://mathias-kettner.de/download'
default['check_mk']['version'] = '1.2.2p3'
default['check_mk']['deb']['release'] = '2'
default['check_mk']['rpm']['release'] = '1'
default['check_mk']['agent']['rpm']['checksum'] = '6112d23c7282168945bfda930e7c27c00fa979d5f3f45f3225e14850f5e5f369'
default['check_mk']['agent']['deb']['checksum'] = '28394424ba756ba306f1a65f520ff0a5c4cd6e85f52be68bf4857d4c9306cff3'
default['check_mk']['agent']['exe']['checksum'] = '5fcf1cdd19c2f403631ebf3d045622a525dcddb23c86d34bfb3ed631542f3acc'
default['check_mk']['logwatch']['rpm']['checksum'] = '35f1875d71466eb6585a0ca8f569f1924a213a85a39db35ed1def705e9683b80'
default['check_mk']['logwatch']['deb']['checksum'] = '53cd92643f5f78de0ae04a43d19eba3e77173356b9da9db1d0989d8685630a46'
default['check_mk']['source']['tar']['checksum'] = '36b78548b38064295b5293f7fa10edbf4655e3cef8e5ae757de8b70ed229213f'
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
