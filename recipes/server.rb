#
# Cookbook Name:: icinga
# Recipe:: server
#
# Copyright 2012, BigPoint GmbH
#
# All rights reserved - Do Not Redistribute
#

# Needed to build check_mk from source (no debian package available)
include_recipe "build-essential"

# Install Apache2
include_recipe "apache2"

# Packages required for Apache2 SSL
package "openssl"
package "ssl-cert"

# Apache2 Modules
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_python"

# Enable default ssl host and disable default vhost
apache_site "default-ssl"
apache_site "default" do
  enable false
end

if ['debian', 'ubuntu'].member? node[:platform]
  # We need the backports repository for up-to-date Icinga version
  apt_repository "squeeze-backports" do
    uri "http://backports.debian.org/debian-backports"
    distribution "squeeze-backports"
    components ["main", "non-free"]
    action :add
  end

  # TODO: The install process is a bit messy since debian-backports is not used when finding installation candidates
  # Standard packages required by server
  pkgs = value_for_platform(
      "default" => %w{ xinetd python }
  )

  pkgs.each do |pkg|
    package pkg do
      action :install
    end
  end

  package "rrdcached" do
    version "1.4.3-1"
    action :install
    options "-t squeeze-backports"
  end
  pkgsbackports = value_for_platform(
      ["debian", "ubuntu"] =>
          {"default" => %w{ icinga icinga-cgi icinga-core icinga-doc }}
  )
  %w{ icinga icinga-cgi icinga-core icinga-doc }.each do |pkg|
    package pkg do
      version node["icinga"]["version"]
      action :install
      # TODO: Properly find the backports repo to use
      #     options  "-t #{node[:os_codename]}-backports"
      options "-t squeeze-backports"
    end
  end

  # Install pnp4nagios now to avoid Nagios3 dependency
  package "pnp4nagios" do
    version node["pnp4nagios"]["version"]
    action :install
    # TODO: Properly find the backports repo to use
    #     options  "-t #{node[:os_codename]}-backports"
    options "-t squeeze-backports"
  end

  # Define all services
  %w{ icinga npcd xinetd rrdcached }.each do |svc|
    service svc do
      supports :status => true, :restart => true, :reload => true
      action :enable
    end
  end

  # Version alias for check_mk
  version = node['check_mk']['version']

  # Source of check_mk
  remote_file "#{Chef::Config[:file_cache_path]}/check_mk-#{version}.tar.gz" do
    source "#{node["check_mk"]["url"]}/check_mk-#{version}.tar.gz"
    mode "0644"
    checksum node["check_mk"]["source"]["tar"]["checksum"] # A SHA256 (or portion thereof) of the file.
  end

  # Add the setup template to compile check_mk
  template "/root/.check_mk_setup.conf" do
    source "check_mk/server/check_mk_setup.conf.erb"
    owner 'root'
    group 'root'
    mode 0640
  end

  bash "build check_mk" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
    tar -xzf check_mk-#{version}.tar.gz
    (cd check_mk-#{version} && echo OK)
    (cd check_mk-#{version} && ./setup.sh --yes)
    # Add www-data to Nagios group (Better in chef?)
    usermod -G nagios www-data
    EOF
    not_if "which check_mk"
  end

  # Remove some default files
  %w{ /etc/icinga/objects/extinfo_icinga.cfg /etc/icinga/objects/hostgroups_icinga.cfg /etc/icinga/objects/localhost_icinga.cfg /etc/icinga/objects/services_icinga.cfg }.each do |f|
    file f do
      action :delete
    end
  end

  # Change some permissions
  %w{ /var/lib/icinga/rw /etc/icinga /etc/check_mk/conf.d /etc/check_mk/conf.d/wato /etc/check_mk/conf.d /etc/check_mk/multisite.d /etc/check_mk/multisite.d/wato }.each do |d|
    file d do
      owner "nagios"
      group "www-data"
      mode "770"
    end
  end
  %w{ /etc/icinga/htpasswd.users /etc/check_mk/conf.d/distributed_wato.mk }.each do |f|
    file f do
      mode "640"
      owner "www-data"
      group "nagios"
    end
  end

  # Needs suid to run as root from by nagios
  file "/usr/lib64/nagios/plugins/check_icmp" do
    mode "4750"
    owner "root"
    group "nagios"
  end

  # pnp4nagios templates
  template "/etc/apache2/conf.d/pnp4nagios.conf" do
    source "pnp4nagios/pnp4nagios.conf.erb"
    owner 'root'
    group 'root'
    mode 0640
    notifies :reload, resources(:service => "apache2")
  end
  template "/etc/pnp4nagios/apache.conf" do
    source "pnp4nagios/pnp4nagios.conf.erb"
    owner 'root'
    group 'root'
    mode 0640
  end
  template "/etc/default/npcd" do
    source "pnp4nagios/npcd.erb"
    owner 'root'
    group 'root'
    mode 0640
    notifies :restart, resources(:service => "npcd")
  end
  template "/etc/pnp4nagios/process_perfdata.cfg" do
    source "pnp4nagios/process_perfdata.cfg.erb"
    owner 'root'
    group 'root'
    mode 0644
  end
  template "/etc/default/rrdcached" do
    source "rrdcached/rrdcached.erb"
    owner 'root'
    group 'root'
    mode 0640
    notifies :restart, resources(:service => "rrdcached")
  end
  template "/etc/pnp4nagios/config.php" do
    source "pnp4nagios/pnp4nagios_config.php.erb"
    owner 'root'
    group 'www-data'
    mode 0640
  end

  # Multisite Configuration
  template "/etc/check_mk/multisite.mk" do
    source "check_mk/server/multisite.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
  end
  template "/etc/check_mk/multisite.d/wato_config.mk" do
    source "check_mk/server/wato_config.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
  end

  # Icinga Configuration
  template "/etc/icinga/icinga.cfg" do
    source "icinga/icinga.cfg.erb"
    owner 'nagios'
    group 'nagios'
    mode 0640
    notifies :restart, resources(:service => "icinga")
  end

  # check_mk livestatus xinetd template
  template "/etc/xinetd.d/livestatus" do
    source "check_mk/server/livestatus.erb"
    owner 'root'
    group 'root'
    mode 0640
    notifies :reload, resources(:service => "xinetd")
  end

  # check_mk default template for icinga
  template "/usr/share/check_mk/check_mk_templates.cfg" do
    source "check_mk/server/check_mk_templates.cfg.erb"
    owner 'root'
    group 'root'
    mode "644"
    notifies :reload, resources(:service => "icinga")
  end

  users = Array.new
  # get group from databag
  node['check_mk']['groups'].each do |groupid|
    # get the group data bag
    group = data_bag_item('groups', groupid)
    # for every member
    group["members"].each do |userid|
      users.push(data_bag_item("users", userid))
    end
  end

  # Ensure all users run the default sidebar, do not overwrite if it exists already
  users.each do |user|
    directory node["check_mk"]["setup"]["vardir"] + "/web/" + user['id'] do
      owner "www-data"
      group "root"
      mode "0750"
      action :create
    end
    template node["check_mk"]["setup"]["vardir"] + "/web/" + user['id'] + "/sidebar.mk" do
      source "check_mk/server/user/sidebar.mk.erb"
      owner "www-data"
      group "root"
      mode 0640
      action :create_if_missing
    end
  end

  template node["icinga"]["htpasswd"]["file"] do
    source "icinga/htpasswd.users.erb"
    owner 'www-data'
    group 'root'
    mode "440"
    variables(
        :users => users
    )
  end

  template "/etc/check_mk/multisite.d/users.mk" do
    source "check_mk/server/users.mk.erb"
    owner 'root'
    group 'root'
    mode "644"
    variables(
        :users => users
    )
  end

  # Add all nodes (for now) to this monitoring server

  # Command definition to reload check_mk when template changed
  execute "reload-check-mk" do
    command "check_mk -I ; check_mk -O"
    action :nothing
  end

  # Find nodes in our environment
  nodes = search(:node, "hostname:[* TO *] AND chef_environment:#{node.chef_environment}")

  # If no nodes are found only add ourselves
  if nodes.empty?
    Chef::Log.info("Not able to find any nodes in this environment.")
    nodes = Array.new
    nodes << node
  end

  # Search for all roles and environments to create hostgroups to use as check_mk tags
  roles = search(:role, 'name:*');
  environments = search(:environment, 'name:*')

  # Search all nodes for tags and os and add them to check_mk tagging and hostgroups
  tags = Array.new
  os_list = Array.new
  nodes.each do |client_node|
    client_node['tags'].each do |tag|
      tags.push(tag)
    end
    os_list.push(client_node['os'])
  end
  os_list.uniq
  tags.uniq

  # Add all found nodes to this server
  template "/etc/check_mk/conf.d/monitoring-nodes-#{node['hostname']}.mk" do
    source "check_mk/server/client_nodes.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
    variables(
        :nodes => nodes
    )
    notifies :run, "execute[reload-check-mk]"
  end

  # Add all roles as hostgroups as they are used as tags for nodes
  template "/etc/check_mk/conf.d/hostgroups-#{node['hostname']}.mk" do
    source "check_mk/server/hostgroups.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
    variables(
        :roles => roles,
        :environments => environments,
        :tags => tags,
        :os_list => os_list
    )
    notifies :run, "execute[reload-check-mk]"
  end

  # Global configuration settings
  template "/etc/check_mk/conf.d/global-configuration.mk" do
    source "check_mk/server/global_config.mk.erb"
    owner "nagios"
    group "nagios"
    mode 0640
    notifies :run, "execute[reload-check-mk]"
  end
end

# Install the Icinga client recipe
include_recipe "icinga::client"