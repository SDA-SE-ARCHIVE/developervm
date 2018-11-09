# -*- mode: ruby -*-
# vi: set ft=ruby :

homeFile = File.join(File.dirname(__FILE__), "home.vdi")

Vagrant.configure("2") do |config|
  if not File.exists?(homeFile)
    print "Please enter your username: "
    username = STDIN.gets.chomp
  end

  config.vm.box = "fedora/sdase-development"
  config.vm.box_url="http://virtualbox.s3.eu-de.objectstorage.softlayer.net/sdase-development-v1.0.0.box?AWSAccessKeyId=0ddef02f11354a89bc95f45b6a71082c&Expires=1607004000&Signature=g2cJ5jI17JZZ3NdpfJu%2FgMw0VfE%3D"
  config.vm.box_download_insecure = true
  config.vm.hostname = "DevelopmentBox"

  config.vm.synced_folder ".", "/vagrant"

  config.vm.provision "creates user and settings", type: "ansible_local" do |ansible|
    ansible.playbook = "user-config.yml"
    ansible.extra_vars = {
        u_name: username
    }
  end

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.memory = 10240
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--monitorcount", "2"]
    vb.customize ["modifyvm", :id, "--vram", "100"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.name = "DevelopmentBox"
    vb.customize ["createhd", "--filename", "#{homeFile}", "--size", "42768"]
    vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata"]
    vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "1", "--type", "hdd", "--medium", "#{homeFile}"]
    #first we need the emptydrive than the addiditons - otherwise the additions file will not be found
    vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "emptydrive"]
    vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "additions"]
  end
end
