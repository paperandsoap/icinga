Description [![Build Status](https://travis-ci.org/Bigpoint/icinga.png?branch=master)](https://travis-ci.org/Bigpoint/icinga)
===========

Icinga offers a monitoring package for both servers and clients. In addition to that it can be expanded using check_mk
to support server aggregation on a single master node.

Node discovery can be configured using a node attribute, defaults to "all hosts in your environment". Check_MK can
also be configured using a node attribute to find its monitoring servers for service aggregation, defaults to "all
monitoring-server roles".

Check_MK is used for automated host and service generation in Icinga, chef is used to populate check_mk with the
appropriate configuration files for this node.


Requirements
============

Chef
----

Chef version 0.12.0+ is required for chef environment usage. See __Environments__ under __Usage__ below.

All users in the __users__ Data Bag and part of the group __check-mk-admins__ from the __groups__ Data Bag will
be added as admins to view and control the Master and each Server.

Since it is using a lot of search functionality this cookbook can only be used if the ChefSolo search libraries
are available.

Platform
--------

 * Debian 6 (Server + Client)
 * CentOS 6 (Client only)
 * Ubuntu 12.04 (Client only)

Cookbooks
---------

 * apt
 * build-essential
 * apache2
 * mod_python

Packages
--------

 * xinetd (for check_mk livestatus and agent)
 * ethtool (for check_mk agent, net link speed detection)

Package Sources
---------------

The server is currently only available for Debian 6. It uses the Squeeze Backports repository to install the 1.7 version
of Icinga. Newer versions might work but have not been tested with this cookbook.


Attributes
==========

Please take a look at the default.rb attributes file for further information on all attributes used.
It includes all variables used in the icinga.cfg and various other configuration files used. For information on each
variable please use the appropriate application documentation. Attributes should all be set to a sane environment and
allow you to deploy Icinga instantly.


Recipes
=======

default
-------

The default recipe will install the `icinga::client` recipe.

client
------

The `icinga::client` recipe will install and configure the check_mk client and xinetd.

server
------

The `icinga::server` recipe installs Apache as web frontend for check_mk Multisite. User are fetched from the `users`
data bag and only enabled if they are part of the check-mk-admin group.

The recipe does the following:

 * Install all depending software for Icinga and Check_mk
 * Search all available nodes in the node's `chef_environment`
 * Create the appropriate check_mk configuration files for the nodes including host tags
 * Create hostgroups configurations in check_mk
 * Enables the Icinga and check_mk Multisite web frontend
 * Find users in the defined groups in default["check_mk"]["groups"] and add them as admins

master
------

The `icinga::master` recipe will install the `icinga::server` recipe and add the multisite site configuration
for server aggregation in the check_mk Multisite web GUI. All nodes with the role `monitoring-server` will be
added to the configuration.


Usage
=====

Once installed the monitoring server will automatically search for all nodes in its environment. Ensure all nodes
in this environment have the `icinga::client` recipe installed otherwise no services will be monitored.

Service Monitoring
------------------

Once installed each service that requires monitoring needs to be added to the Icinga cookbook. Two components
are required for this check to work:

 * Check_mk Check on the Icinga Server
 * Check_mk Plugin on the Service Node

 The plugin is used to fetch data from your service that is being monitored on the Icinga Server by check_mk checks.

 For further details how to write native check_mk agents please refer to the official documentation:

  * http://mathias-kettner.de/checkmk_devel_agentbased.html

Environments
------------

The install recipe for the server is using chef environments to find all nodes within the Icinga servers environment.
Be aware that this is a feature requiring Chef >= 0.10.0 to work.

Vagrant
=======

Search Functions
----------------

To allow searching for nodes, roles, environments as used in this recipe ensure you have created the required
data bags and have the ChefSolo search library installed. Below an overview of different search replacements.

```
 --- data_bags
             \- node
             |      \- nodeN.json
             |- users
             |      \- userN.json
             |- groups
             |      \- groupN.json
             |- role
             |      \- roleN.json
             |- environment
                    \- envN.json
```

# Node Data Bag Item

Here a minimalistic node that can be used in Node Searches within
Chef Solo

```
{
  "name":"icinga-server-01",
  "chef_environment":"_default",
  "json_class":"Chef::Node",
  "automatic":{
    "network":{
      "interfaces":{
        "eth0":{
          "addresses":{
            "10.0.2.15":{
              "scope": "Global",
              "netmask": "255.255.255.0",
              "broadcast": "10.0.2.255",
              "prefixlen": "24",
              "family": "inet"
            }
          }
        },
        "eth1":{
          "addresses":{
            "8.1.1.8":{
              "scope": "Global",
              "netmask": "255.255.255.0",
              "broadcast": "8.1.1.255",
              "prefixlen": "24",
              "family": "inet"
            }
          }
        }
      }
    },
    "platform_version":"6.0.5",
    "domain": "local",
    "fqdn":"icinga-server-01.local",
    "ipaddress":"127.0.0.1",
    "os":"linux",
    "lsb":{
      "codename":"squeeze",
      "id":"Debian",
      "description":"Debian GNU/Linux 6.0.5 (squeeze)",
      "release":"6.0.5"
    },
    "os_version":"2.6.32-5-amd64",
    "platform_family":"debian",
    "recipes":[
    ],
    "hostname":"icinga-server-01"
  },
  "normal": {
    "tags":[
      "testing-tag-01"
    ],
    "id":"icinga-server-01",
    "roles": [
      "base",
      "monitoring-server"
    ],
    "platform": "debian"
  },
  "chef_type":"node",
  "run_list":[
    "role[base]",
    "role[monitoring-server]"
  ]
}
```

# Group Data Bag Item

This data bag item is used to match users against access groups.

```
{
  "id" : "check-mk-admin",
  "members" : ["icingaadmin"]
}
```

# User Data Bag Item

This data bag item defines the user that will be allowed access if
member of the check-mk-admin group. The password is the hash as created
by htpasswd. Used here is a hash for the password `test`.

```
{
  "id": "icingaadmin",
  "htpasswd" : "$apr1$mXxUCwMY$dePujmMXMOd9yPZyXaQ6Q0",
  "enabled" : true
}
```

# Environment Data Bag Item

This item is used by Icinga to create environments as hostgroups and
tags automatically and must exist for the Cookbook to work in Chef Solo.

```
{
    "name":"_default",
    "description":"The default Chef environment",
    "cookbook_versions":{
    },
    "json_class":"Chef::Environment",
    "chef_type":"environment",
    "default_attributes":{
    },
    "override_attributes":{
    },
    "_rev":"1-8e5cd47aca08b855b1583ac7bf4da2ec"
}
```

# Role Data Bag Item

This item is used by Icinga to create environments as hostgroups and
tags automatically and must exist for the Cookbook to work in Chef Solo.

```
{
    "name":"monitoring-server",
    "description":"Icinga Monitoring Host",
    "json_class":"Chef::Role",
    "default_attributes":{
        "apache2":{
            "listen_ports":[
                "80",
                "443"
            ]
        }
    },
    "override_attributes":{
    },
    "chef_type":"role",
    "run_list":[
        "recipe[apache2]",
        "recipe[apache2::mod_ssl]",
        "recipe[icinga::server]",
        "recipe[icinga::client]"
    ],
    "env_run_lists":{
    },
    "_rev":"4-c82859239100d64b25f2d121baa4cfd2"
}
```


Vagrantfile
-----------

Please ensure you have forwarded port 443 to your local machine to access the WebUI.
No other special settings are required in the Vagrantfile for this cookbook to work.

# Exmaple Vagrantfile

This vagrantfile is used while testing the cookbook functionality. When
using the data bags explained above you should be able to get it going
quickly.

```
# vi: set ft=ruby :

# require File.expand_path('../../lib/librarian/vagrant', __FILE__)
# require File.expand_path('../../lib/berkshelf/vagrant', __FILE__)

Vagrant::Config.run do |config|
  # Debian Squeeze, 64 bit
  config.vm.box = "squeeze64"
  # Internal URL, no public access
  config.vm.box_url = "<your-squeeze-box-URL>"
  config.vm.host_name = "icinga-server-01.local"
  config.vm.customize ["modifyvm", :id, "--memory", 2048]
  config.vm.customize ["modifyvm", :id, "--cpus", "2"]

  # Port forwarding
  config.vm.forward_port 443, 4443

  # Chef Solo provisioner
  config.vm.provision :chef_solo do |chef|
    # Paths relative to Vagrantfile
    chef.cookbooks_path = ['cookbooks']
    chef.data_bags_path = "data_bags"
    chef.add_recipe "apt"
    chef.add_recipe "icinga::server"
    chef.log_level = :debug
    chef.json = {
      "lsb" => { "codename" => "squeeze" },
      "pnp4nagios" => { "htpasswd" => { "file" => "/etc/icinga/htpasswd.users" } },
      "rrdcached" => { "config" => { "options" => "-s nagios -m 0660 -l unix:/var/run/rrdcached/rrdcached.sock -F -w 1800 -z 1800", "socket" => "unix:/var/run/rrdcached/rrdcached.sock" } }
    }
  end
end
```


Software Links
==============

This cookbooks uses various pieces of software, either prepackaged or from source code. Please check their sites for
further documentation.

* Check_MK : http://mathias-kettner.de/check_mk.html
* Icinga : https://www.icinga.org/


Poem
=======

'Die Sonne scheint mir auf den Bauch,
     soll sie auch' - Heinz Erhardt


License and Author
==================

Author:: Sebastian Grewe <sebgrewe@bigpoint.net>

Copyright 2012, Bigpoint GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
