#!/bin/bash

Vagrant_Directory() {
  echo $(Files_Path_Root)/.vagrant
}

Vagrant_Exists() {
  local machine=$1

  echo $(Vagrant_Directory)/Vagrantfile.$machine
  if [ -f $(Vagrant_Directory)/Vagrantfile.$machine ] ; then
    return 0
  else
    return 1
  fi
}

Vagrant_Up() {
  local machine=$1

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  cd $(Vagrant_Directory)
  VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant up
  local exitCode=$?
  cd - > /dev/null

  return $exitCode
}

Vagrant_Halt() {
  local machine=$1

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  cd $(Vagrant_Directory)
  VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant halt
  local exitCode=$?
  cd - > /dev/null

  return $exitCode
}

Vagrant_Destroy() {
  local machine=$1

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  cd $(Vagrant_Directory)
  VAGRANT_VAGRANTFILE=Vagrantfile.$machine VAGRANT_DOTFILE_PATH=$(Files_Path_Root)/.vagrant vagrant destroy -f
  local exitCode=$?
  cd - > /dev/null

  return $exitCode
}