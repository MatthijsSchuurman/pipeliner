Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.synced_folder ".", "/home/vagrant/pipeliner"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 512
    vb.cpus = 2
  end

  config.vm.define :default, primary: true do |config|
    name = "pipeliner-default"
    config.vm.hostname = name
    config.vm.provider "virtualbox" do |vb|
      vb.name = name
    end

    config.vm.provision "shell", inline: <<-SHELL
      echo "Pipeliner Default VM"
    SHELL
  end

  config.vm.define :azdo do |config|
    name = "pipeliner-azdo"
    config.vm.hostname = name
    config.vm.provider "virtualbox" do |vb|
      vb.name = name
    end

    config.vm.provision "shell", inline: <<-SHELL
      echo "Pipeliner AZDO VM"
    SHELL
  end

end
