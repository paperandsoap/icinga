Description
===========

Icinga offers a monitoring package for both servers and clients. In addition to that it can be expanded
to support server aggregation on a single master node.

It is configured to find all nodes in it's segment automatically while the master server looks for all
monitoring-serer roles in a network segment (environment).

check_mk is used for automated host and service generation in Icinga, chef is used to populate check_mk with the
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
 * CentOS 6 (Client)
 * Ubuntu 12.04 (Client)

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

Attributes
==========

Please take a look at the default.rb attributes file for further information on all attributes used.
It includes all variables used in the icinga.cfg and various other configuration files used. For information on each
variable please use the appropriate application documentation.


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
data bag.

The recipe does the following:

 * Install all depending software for Icinga and Check_mk
 * Search all available nodes in the node's `chef_environment`
 * Create the appropriate check_mk configuration files for the nodes including host tags
 * Create hostgroups configurations in check_mk
 * Disables the 000-default VirtualHost
 * Enables the Icinga and check_mk Multisite web front end configuration
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
data bags and have the ChefSolo search library installed.

```
 --- data_bags
             \- node
             |      \- nodeN.json
             |- role
             |      \- roleN.json
             |- environment
                    \- envN.json
```

Vagrantfile
-----------

Please ensure you have forwarded port 443 to your local machine to access the WebUI.
No other special settings are required in the Vagrantfile for this cookbook to work.


TODO
====

 * Remove version string dependency in the default.rd file and use proper repositories for the client
 * Nice to have: Package for check_mk server components


Poem
=======

'Die Sonne scheint mir auf den Bauch,
     soll sie auch' - Heinz Erhardt


License and Author
==================

Author:: Sebastian Grewe <sebgrewe@bigpoint.net>

Copyright 2012, BigPoint GmbH

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
