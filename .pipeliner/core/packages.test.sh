#!/bin/bash

source $(Files_Path_Pipeliner)/core/packages.sh

UnitTest_Packages_Installed() {
  #Given

  #When & Then
  if Packages_Installed "ls"; then
    Assert_Equal true true
  else
    Assert_Equal true false
  fi

  #When & Then
  if ! Packages_Installed "unknowntool"; then
    Assert_Equal true true
  else
    Assert_Equal true false
  fi
}

UnitTest_Packages_Version() {
  #Given
  local actual=

  #When
  actual=$(Packages_Version bash)

  #Then
  Assert_Match "$actual" "GNU bash.*version [0-9\.]+"

  #When
  actual=$(Packages_Version wget)

  #Then
  Assert_Match "$actual" "GNU Wget [0-9\.]+"

  #When
  actual=$(Packages_Version ssh)

  #Then
  Assert_Match "$actual" "OpenSSH_[0-9\.]+"
}

UnitTest_Packages__Determine_Manager() {
  #Given
  local actual=

  #When
  actual=$(Packages__Determine_Manager)

  #Then
  case $actual in
    "apt" | "pacman" | "yum" | "apk" | "brew")
      Assert_Equal true true
      ;;
    *)
      Assert_Equal true false
      ;;
  esac
}

UnitTest_Packages__Determine_Packages() {
  #Given
  local package=

  #When
  package=$(Packages__Determine_Packages wget)

  #Then
  Assert_Equal $package wget
}
UnitTest_Packages__Determine_Packages_SSH() {
  #Given
  local package=

  #When
  package=$(Packages__Determine_Packages ssh)

  #Then
  Assert_Equal $package openssh

  #When
  package=$(Packages__Determine_Packages scp)

  #Then
  Assert_Equal $package openssh

  #When
  package=$(Packages__Determine_Packages ssh-keygen)

  #Then
  Assert_Equal $package openssh
}
UnitTest_Packages__Determine_Packages_ZIP() {
  #Given
  local package=

  #When
  package=$(Packages__Determine_Packages zip)

  #Then
  Assert_Equal "$package" "zip unzip"

  #When
  package=$(Packages__Determine_Packages unzip)

  #Then
  Assert_Equal "$package" "zip unzip"
}
UnitTest_Packages__Determine_Packages_Docker() {
  #Given
  local package=
  Packages__Determine_Manager() { #mock
    echo "apt"
  }

  #When
  package=$(Packages__Determine_Packages docker)

  #Then
  Assert_Equal "$package" "docker.io"


  #Given
  Packages__Determine_Manager() { #mock
    echo "pacman"
  }

  #When
  package=$(Packages__Determine_Packages docker)

  #Then
  Assert_Equal "$package" "docker"
}

UnitTest_Packages__Determine_Services() {
  #Given
  local services=

  #When
  services=$(Packages__Determine_Services ssh)

  #Then
  Assert_Equal $services ssh.service

  #When
  services=$(Packages__Determine_Services docker)

  #Then
  Assert_Equal "$services" "docker.service docker.socket"
}

UnitTest_Packages_Update() {
  #Given
  local actual=
  local exitCode=

  sudo() { #mock
    echo "sudo $@"
  }

  Packages__Determine_Manager() { #mock
    echo "apt"
  }

  #When
  actual=$(Packages_Update)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Updating package list" ENDGROUP
  else
    Assert_Contains "$actual" group "Updating package list" endgroup
  fi

  Assert_Contains "$actual" "sudo apt update"


  #Given
  Packages__Determine_Manager() { #mock
    echo "pacman"
  }

  #When
  actual=$(Packages_Update)

  #Then
  Assert_Contains "$actual" "sudo pacman -Sy"


  #Given
  Packages__Determine_Manager() { #mock
    echo "yum"
  }

  #When
  actual=$(Packages_Update)

  #Then
  Assert_Contains "$actual" "sudo yum update"


  #Given
  Packages__Determine_Manager() { #mock
    echo "apk"
  }

  #When
  actual=$(Packages_Update)

  #Then
  Assert_Contains "$actual" "sudo apk update"
}
UnitTest_Packages_Update_Fail() {
  #Given
  local actual=

  sudo() { #mock
    return 1
  }

  Packages__Determine_Manager() { #mock
    echo "apt"
  }

  #When
  actual=$(Packages_Update)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Failed to update package list"
  else
    Assert_Contains "$actual" error "Failed to update package list"
  fi

  #Given
  Packages__Determine_Manager() { #mock
    echo "unknown"
  }

  #When
  actual=$(Packages_Update)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Package manager not supported: unknown"
  else
    Assert_Contains "$actual" error "Package manager not supported: unknown"
  fi
}

UnitTest_Packages_Install() {
  #Given
  local actual=
  local exitCode=

  sudo() { #mock
    echo "sudo $@"
  }

  Packages__Determine_Manager() { #mock
    echo "apt"
  }

  #When
  actual=$(Packages_Install ssh)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Installing package: openssh" ENDGROUP
  else
    Assert_Contains "$actual" group "Installing package: openssh" endgroup
  fi

  Assert_Contains "$actual" "sudo apt install -y openssh"


  #Given
  Packages__Determine_Manager() { #mock
    echo "pacman"
  }

  #When
  actual=$(Packages_Install zip)

  #Then
  Assert_Contains "$actual" "sudo pacman -S --noconfirm zip unzip"


  #Given
  Packages__Determine_Manager() { #mock
    echo "yum"
  }

  #When
  actual=$(Packages_Install wget)

  #Then
  Assert_Contains "$actual" "sudo yum install -y wget"


  #Given
  Packages__Determine_Manager() { #mock
    echo "apk"
  }

  #When
  actual=$(Packages_Install curl)

  #Then
  Assert_Contains "$actual" "sudo apk add curl"
}
UnitTest_Packages_Install_Fail() {
  #Given
  local actual=

  sudo() { #mock
    return 1
  }

  Packages__Determine_Manager() { #mock
    echo "apt"
  }

  #When
  actual=$(Packages_Install ssh)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Failed to install package: openssh"
  else
    Assert_Contains "$actual" error "Failed to install package: openssh"
  fi

  #Given
  Packages__Determine_Manager() { #mock
    echo "unknown"
  }

  #When
  actual=$(Packages_Install ssh)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Package manager not supported: unknown"
  else
    Assert_Contains "$actual" error "Package manager not supported: unknown"
  fi
}

UnitTest_Packages_Start_Service() {
  #Given
  local actual=
  local exitCode=

  sudo() { #mock
    echo "sudo $@"
  }

  #When
  actual=$(Packages_Start_Service ssh)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Starting service: ssh.service" ENDGROUP
  else
    Assert_Contains "$actual" group "Starting service: ssh.service" endgroup
  fi

  Assert_Contains "$actual" "sudo systemctl start ssh.service"


  #When
  actual=$(Packages_Start_Service docker)

  #Then
  Assert_Contains "$actual" "sudo systemctl start docker.service"
  Assert_Contains "$actual" "sudo systemctl start docker.socket"
}
UnitTest_Packages_Start_Service_Fail() {
  #Given
  local actual=

  sudo() { #mock
    return 1
  }

  #When
  actual=$(Packages_Start_Service ssh)

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Failed to start service: ssh.service"
  else
    Assert_Contains "$actual" error "Failed to start service: ssh.service"
  fi
}

UnitTest_Packages_Prerequisites() {
  #Given
  local actual=
  local exitCode=

  Packages_Installed() { #mock
    return 1
  }

  Packages_Update() { #mock
    echo "Packages_Update"
  }

  Packages_Install() { #mock
    echo "Packages_Install $@"
  }

  Packages_Start_Service() { #mock
    echo "Packages_Start_Service $@"
  }

  #When
  actual=$(Packages_Prerequisites ssh)

  #Then
  Assert_Contains "$actual" "Packages_Update"
  Assert_Contains "$actual" "Packages_Install ssh"
  Assert_Contains "$actual" "Packages_Start_Service ssh"
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "OpenSSH_[0-9\.]+"
  else
    Assert_Match "$actual" debug "OpenSSH_[0-9\.]+"
  fi


  #When
  actual=$(Packages_Prerequisites wget)

  #Then
  Assert_Contains "$actual" "Packages_Update"
  Assert_Contains "$actual" "Packages_Install wget"
  Assert_Not_Contains "$actual" "Packages_Start_Service"
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "GNU Wget [0-9\.]+"
  else
    Assert_Match "$actual" debug "GNU Wget [0-9\.]+"
  fi


  #Given
  Packages_Installed() { #mock
    return 0
  }

  #When
  actual=$(Packages_Prerequisites unzip)

  #Then
  Assert_Not_Contains "$actual" "Packages_Update"
  Assert_Not_Contains "$actual" "Packages_Install"
  Assert_Not_Contains "$actual" "Packages_Start_Service"
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "UnZip [0-9\.]+"
  else
    Assert_Match "$actual" debug "UnZip [0-9\.]+"
  fi
}