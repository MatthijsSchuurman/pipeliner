#!/bin/bash

Vagrant_Exists() {
  local machine=$1

  grep -q "config.vm.define :$machine" $(Files_Path_Root)/Vagrantfile
  return $?
}

Vagrant_Running () {
  local machine=$1

  if ! Vagrant_Exists $machine ; then
    Log_Error "Vagrant file for machine $machine does not exist"
    return 1
  fi

  vagrant status "$machine" | grep "$machine\s*running" > /dev/null
  local exitCode=$?

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
    vagrant up "$machine"
    local exitCode=$?
  fi

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

  if [ "$commands" ]; then
    vagrant ssh "$machine" -c "$commands"
    local exitCode=$?
  else
    vagrant ssh "$machine"
    local exitCode=$?
  fi

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
    vagrant halt "$machine"
    local exitCode=$?
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

  vagrant destroy "$machine" -f
  local exitCode=$?

  Log_Group_End
  return $exitCode
}