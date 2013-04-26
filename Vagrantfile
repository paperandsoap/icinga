# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Debian Squeeze, 64 bit
  config.vm.box = "squeeze64"
  # Internal URL, no public access
  config.vm.box_url = "http://debbuild.bigpoint.net/squeeze64.box"
  config.vm.host_name = "icinga-server-01.local"
  config.vm.network :hostonly, "8.1.1.8"
  config.vm.customize ["modifyvm", :id, "--memory", 1024]
  config.vm.customize ["modifyvm", :id, "--cpus", "2"]

  # Port forwarding
  config.vm.forward_port 80, 8080
  config.vm.forward_port 8080, 8081
  config.vm.forward_port 443, 4443

  # Chef Solo provisioner
  config.vm.provision :chef_solo do |chef|
    # Paths relative to Vagrantfile
    chef.cookbooks_path = ['cookbooks', 'dev-cookbooks']
    chef.data_bags_path = "test/data_bags"
    chef.roles_path = "test/data_bags/role"
    chef.add_recipe "up2date"
    chef.add_recipe "chef-solo-search"
    chef.add_recipe "icinga::server"
    chef.add_recipe "exim4-light"
    chef.log_level = :debug
    chef.json = {
      "exim4" => { "configtype" => "internet" },
      "lsb" => { "codename" => "squeeze" },
      "pnp4nagios" => { "htpasswd" => { "file" => "/etc/icinga/htpasswd.users" } },
      "rrdcached" => { "config" => {
        "options" => "-s nagios -m 0660 -l unix:/var/run/rrdcached/rrdcached.sock -F -w 1800 -z 1800",
        "socket" => "unix:/var/run/rrdcached/rrdcached.sock" } }
    }
  end
end
