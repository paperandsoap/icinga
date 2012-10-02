maintainer "BigPoint GmbH"
maintainer_email "sebgrewe@bigpoint.net"
license "All rights reserved"
description "Installs/Configures Icinga and check_mk Monitoring Solution"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.1.26"

recipe "bp-icinga", "Icinga Client Monitoring"
recipe "bp-icinga::server", "Icinga Monitoring Server and node discovery for the server node environment"
recipe "bp-icinga::master", "Icinga Monitoring Server and Master with monitoring-server role discovery"

# Default settings used in configuration options below
attribute "pnp4nagios/config/rrdbase",
          :display_name => "pnp4nagios Perfdata Path",
          :description => "Base path where pnp4nagios will place performance data rrd graphs.",
          :default => "/var/lib/pnp4nagios/perfdata/"

attribute "rrdcached/config/socket",
          :display_name => "rrdached Unix Socket path",
          :description => "RRDCached full path to the socket.",
          :default => "unix:/var/run/rrdcached.sock"

attribute "icinga/version",
          :display_name => "Icinga Version to install",
          :description => "Icinga Debian Package version string",
          :default => "1.7.1-3~bpo60+1"

attribute "pnp4nagios/version",
          :display_name => "pnp4nagios Version to install",
          :description => "pnp4nagios Debian Package version string",
          :default => "0.6.12-1~bpo60+1"

attribute "icinga/user",
          :display_name => "Icinga system user",
          :description => "Username for the Icinga daemon process",
          :default => "nagios"

attribute "icinga/group",
          :display_name => "Icinga system group",
          :description => "Group for the Icinga daemon process",
          :default => "nagios"

attribute "icinga/htpasswd/file",
          :display_name => "Icinga htpasswd file",
          :description => "Icinga authenticaion file where user databags will be stored.",
          :default => "/etc/icinga/htpasswd.users"

attribute "check_mk/version",
          :display_name => "Check_mk version",
          :description => "Check_mk version to be installed from source and DEB/RPM package.",
          :default => "1.2.1i1"

attribute "check_mk/deb/release",
          :display_name => "Check_mk .deb minor release",
          :description => "Check_mk .dev minor release version.",
          :default => "2"

attribute "check_mk/rpm/release",
          :display_name => "Check_mk .rpm minor release",
          :description => "Check_mk .rpm minor release version.",
          :default => "1"

attribute "check_mk/groups",
          :display_name => "Check_mk groups",
          :description => "Check_mk contact groups. Used to find users in the data bags.",
          :default => "1"

depends "build-essential", ">= 1.1.2"
depends "apache2", ">= 1.1.16"
depends "apt", ">= 1.4.8"
