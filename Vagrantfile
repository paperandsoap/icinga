# vi: set ft=ruby :

Vagrant.require_plugin "vagrant-berkshelf"
Vagrant.require_plugin "vagrant-aws"

Vagrant.configure("2") do |config|
  config.vm.box = "squeeze64"
  config.vm.box_url = "http://debbuild.bigpoint.net/squeeze64.box"
  config.vm.hostname = "icinga-server-01.local"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 8080, host: 8081
  config.vm.network :forwarded_port, guest: 443, host: 4443
  config.vm.network :private_network, ip: "8.1.1.8"
  
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end

  config.vm.provider :aws do |aws, override|
    override.vm.box = "aws"
    override.ssh.username = "admin"
    override.ssh.private_key_path = "#{ENV['HOME']}/.ssh/id_rsa.aws-vagrant"
    aws.access_key_id = "#{ENV['AWS_ACCESS_KEY_ID']}"
    aws.secret_access_key = "#{ENV['AWS_SECRET_ACCESS_KEY']}"
    aws.ami = "ami-b30e19c7"
    aws.region = "eu-west-1"
    aws.keypair_name = "vagrant"
    aws.instance_type = "t1.micro"
  end

  # Chef Solo provisioner
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.data_bags_path = "test/data_bags"
    chef.roles_path = "test/data_bags/role"
    chef.add_recipe "up2date"
    chef.add_recipe "chef-solo-search"
    chef.add_recipe "icinga::server"
    chef.add_recipe "exim4-light"
    chef.log_level = :debug
    chef.json = {
      "check_mk" => {
        "isMaster" => 'True',
        "config" => {
          "ignored_services" => [ "ALL_HOSTS, [ \"Monitoring\" ]" ],
          "ignored_checks" => [ "[ \"mysql_capacity\" ], ALL_HOSTS" ]
        },
        "notifications" => {
            "email" => {
                "disabled" => "True"
            },
            "sms" => {
                "disabled" => "True"
            }
        }
      },
      "exim4" => { "configtype" => "internet" },
      "lsb" => { "codename" => "squeeze" },
      "pnp4nagios" => { "htpasswd" => { "file" => "/etc/icinga/htpasswd.users" } },
      "rrdcached" => { "config" => {
        "options" => "-s nagios -m 0660 -l unix:/var/run/rrdcached/rrdcached.sock -F -w 1800 -z 1800",
        "socket" => "unix:/var/run/rrdcached/rrdcached.sock" } }
    }
  end
end
