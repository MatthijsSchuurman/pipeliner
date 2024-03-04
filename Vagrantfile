Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  config.vm.define :default, primary: true do |config|
    name = "pipeliner-default"
    config.vm.hostname = name
    config.vm.provider "virtualbox" do |vb|
      vb.name = name
      vb.memory = 512
      vb.cpus = 2
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
      vb.memory = 512
      vb.cpus = 2
    end

    config.vm.provision "shell", inline: <<-SHELL
      sudo pacman -S --noconfirm wget gzip tar

      # Download and unzip the latest Azure DevOps Agent CLI
      AGENT_VERSION=$(curl -s https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest | grep tag_name | cut -d '"' -f 4)
      AGENT_VERSION=${AGENT_VERSION:1}
      AGENT_URL="https://vstsagentpackage.azureedge.net/agent/$AGENT_VERSION/vsts-agent-linux-x64-$AGENT_VERSION.tar.gz"

      mkdir agent
      cd agent
      wget $AGENT_URL -O agent.tar.gz
      tar -zxvf agent.tar.gz
      rm agent.tar.gz
      cd -
    SHELL
  end

end
