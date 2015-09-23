# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "master" do |master|
    master.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    master.vm.box_version = "= 1.0.1"
    master.vm.network :private_network, ip: "192.168.33.61"
    master.vm.hostname = "master.vagrant.local"
    master.vm.provider :virtualbox do |vb|
      vb.memory = 1024
      vb.name = "master"
    end
  end
  config.vm.define "sattelite" do |sattelite|
    sattelite.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
    sattelite.vm.network :private_network, ip: "192.168.33.62"
    sattelite.vm.hostname = "sattelite.vagrant.local"
    sattelite.vm.provider :virtualbox do |vb|
      vb.memory = 1024
      vb.name = "sattelite"
    end
  end

  config.vm.provision :puppet do |puppet|
    #puppet.options = "--verbose --debug"
    #puppet.environment = "production"
    puppet.manifest_file  = "icinga.pp"
    puppet.module_path = ["modules"]
  end
end
