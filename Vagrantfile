# -*- mode: ruby -*-
# vi: set ft=ruby :

homeFile = File.join(File.dirname(__FILE__), "home.vdi")

Vagrant.configure("2") do |config|
  config.vm.box = "fedora/25-cloud-base"
  config.vm.box_download_insecure = true
  config.vm.hostname = "DevelopmentBox"
  
  config.vm.synced_folder ".", "/vagrant", disabled: true

  if not File.exists?(homeFile)
	config.vm.provision :shell, :path=>"proxy.bash"
	config.vm.provision :shell, :path=>"kernel.bash"
  end
  if File.exists?(homeFile)
	config.vm.provision :shell, :path=>"main.bash"
	config.vm.provision :shell, :path=>"tests.bash"
  end  

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
	vb.memory = 10240
    vb.cpus = 4 
	vb.customize ["modifyvm", :id, "--monitorcount", "2"]
	vb.customize ["modifyvm", :id, "--vram", "100"]
	vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
	vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
	vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']  
	vb.name = "DevelopmentBox"
	
	if not File.exists?(homeFile)
		vb.customize ["createhd", "--filename", "#{homeFile}", "--size", "42768"]
		vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata"]
		vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", "1", "--type", "hdd", "--medium", "#{homeFile}"]
	end
  end
end
