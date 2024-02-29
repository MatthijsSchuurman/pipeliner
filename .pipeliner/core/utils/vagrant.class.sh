#!/bin/bash

Vagrant_Directory() {
  echo $(Files_Path_Root)/.vagrant
}

Vagrant_Exists() {
  local machine=$1

  if [ -f $(Vagrant_Directory)/Vagrantfile.$machine ] ; then
    return 0
  else
    return 1
  fi
}

Vagrant_Running () {
  local machine=$1

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  cd $(Vagrant_Directory)
  VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant status | grep "pipeliner-$machine\s*running" > /dev/null
  local exitCode=$?
  cd - > /dev/null

  return $exitCode
}

Vagrant_Up() {
  local machine=$1

  Log_Group "Vagrant up $machine"
  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    Log_Group_End
    return 1
  fi

  if Vagrant_Running $machine ; then
    Log_Info "Vagrant machine $machine is already running"
  else
    cd $(Vagrant_Directory)
    VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant up
    local exitCode=$?
    cd - > /dev/null
  fi

  Log_Info "cd $(Vagrant_Directory) ; VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant ssh"
  Log_Group_End
  return $exitCode
}

Vagrant_SSH() {
  local machine=$1

  local commands=
  if [ ${#@} -eq 2 ]; then
    commands=$2
  elif [ ${#@} -gt 2 ]; then
    shift 1
    commands=$(IFS=";" ; echo "$*")
  fi

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  cd $(Vagrant_Directory)
  if [ "$commands" ]; then
    VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant ssh -c "$commands"
    local exitCode=$?
  else
    VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant ssh
    local exitCode=$?
  fi
  cd - > /dev/null

  return $exitCode
}

Vagrant_Halt() {
  local machine=$1

  Log_Group "Vagrant halt $machine"
  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    Log_Group_End
    return 1
  fi

  if ! Vagrant_Running $machine ; then
    Log_Info "Vagrant machine $machine is not running"
  else
    cd $(Vagrant_Directory)
    VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant halt
    local exitCode=$?
    cd - > /dev/null
  fi

  Log_Group_End
  return $exitCode
}

Vagrant_Destroy() {
  local machine=$1

  Log_Group "Vagrant destroy $machine"
  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    Log_Group_End
    return 1
  fi

  cd $(Vagrant_Directory)
  VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant destroy -f
  local exitCode=$?
  cd - > /dev/null

  Log_Group_End
  return $exitCode
}