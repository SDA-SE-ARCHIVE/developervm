# -*- mode: ruby -*-
# vi: set ft=ruby :

homeFile = File.join(File.dirname(__FILE__), "home.vdi")

Vagrant.configure("2") do |config|
  print "Please enter your username: "
  username = STDIN.gets.chomp
  print "Please enter 1 or 2 for monitorcount: "
  monitorcount = STDIN.gets.chomp

  config.vm.box = "fedora/sdase-development.1.0.1"
  config.vm.box_url="https://s3.eu-de.cloud-object-storage.appdomain.cloud/virtualbox/sdase-development-v1.0.1.box?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Expires=63072000&X-Amz-Credential=a28f12a7ae03481ba73751cae5a6014f%2F20191104%2Feu-de-standard%2Fs3%2Faws4_request&X-Amz-SignedHeaders=host&X-Amz-Date=20191104T140304Z&X-Amz-Signature=ed2aa331c184c0df17501d9defcde5df9e96a9fd8d85a13aeecaa8378a1531c8"
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
    vb.customize ["modifyvm", :id, "--monitorcount", monitorcount]
    vb.customize ["modifyvm", :id, "--vram", "100"]
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "off"]
    vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
    vb.name = "DevelopmentBox"
    unless File.exist?(File.join(File.dirname(__FILE__), "home.vdi"))
	    vb.customize ["createhd", "--filename", "#{homeFile}", "--size", "42768"]
		vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata"]
		vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "1", "--type", "hdd", "--medium", "#{homeFile}"]
	end
    #first we need the emptydrive than the addiditons - otherwise the additions file will not be found
    vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "emptydrive"]
    vb.customize ["storageattach", :id, "--storagectl", "IDE", "--port", "1", "--device", "0", "--type", "dvddrive", "--medium", "additions"]
  end
end
