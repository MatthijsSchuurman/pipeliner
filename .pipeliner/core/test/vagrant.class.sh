#!/bin/bash

source $(Files_Path_Pipeliner)/core/vagrant.class.sh
source $(Files_Path_Pipeliner)/core/packages.class.sh

UnitTest_Vagrant_Exists() {
  #Given
  local exitCode=
  local machine=default

  #When
  Vagrant_Exists $machine
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
}

UnitTest_Vagrant_Exists_Fail() {
  #Given
  local exitCode=
  local machine=unknown

  #When
  Vagrant_Exists $machine
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
}

UnitTest_Vagrant_Running() {
  exit 255 #Skip so tests won't get slow (done in Vagrant_Up and Vagrant_Halt)
}

UnitTest_Vagrant_Up() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local running=
  local machine=default

  Vagrant_Halt $machine

  #When
  actual=$(Vagrant_Up $machine)
  exitCode=$?

  Vagrant_Running $machine
  running=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal $running 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant up $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant up $machine" endgroup
  fi

  Assert_Contains "$actual" "Bringing machine 'default' up with 'virtualbox' provider..."


  #Given

  #When
  actual=$(Vagrant_Up $machine)
  exitCode=$?

  Vagrant_Running $machine
  running=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal $running 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant up $machine" ENDGROUP
    Assert_Contains "$actual" "INFO Vagrant machine $machine is already running"
  else
    Assert_Contains "$actual" "group Vagrant up $machine" endgroup
    Assert_Contains "$actual" "info Vagrant machine $machine is already running"
  fi
}

UnitTest_Vagrant_Up_Fail() {
  #Given
  local actual=
  local exitCode=
  local running=
  local machine=unknown

  #When
  actual=$(Vagrant_Up $machine)
  exitCode=$?


  Vagrant_Running $machine > /dev/null
  running=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal $running 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant up $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant up $machine" endgroup
  fi

  Assert_Contains "$actual" "Vagrant file for machine $machine does not exist"
}

UnitTest_Vagrant_SSH() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local machine=default

  Vagrant_Up $machine

  #When
  actual=$(Vagrant_SSH $machine "echo 'Hello, World!'")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Hello, World!"


  #Given

  #When
  actual=$(Vagrant_SSH $machine "ls -la" pwd "exit 1")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" drwx /home/vagrant
}

UnitTest_Vagrant_Halt() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local running=
  local machine=default

  Vagrant_Up $machine

  #When
  actual=$(Vagrant_Halt $machine)
  exitCode=$?

  Vagrant_Running $machine
  running=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal $running 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant halt $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant halt $machine" endgroup
  fi

  Assert_Contains "$actual" "==> default: Attempting graceful shutdown of VM..."
}

UnitTest_Vagrant_Halt_Fail() {
  #Given
  local actual=
  local exitCode=
  local running=
  local machine=unknown

  #When
  actual=$(Vagrant_Halt $machine)
  exitCode=$?

  Vagrant_Running $machine
  running=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal $running 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant halt $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant halt $machine" endgroup
  fi

  Assert_Contains "$actual" "Vagrant file for machine $machine does not exist"
}

UnitTest_Vagrant_Destroy() {
  exit 255 #Skip so tests won't get slow

  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local machine=default

  #When
  actual=$(Vagrant_Destroy $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant destroy $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant destroy $machine" endgroup
  fi

  Assert_Contains "$actual" "==> default: Destroying VM and associated drives..."
}

UnitTest_Vagrant_Destroy_Fail() {
  #Given
  local actual=
  local exitCode=
  local machine=unknown

  #When
  actual=$(Vagrant_Destroy $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" "GROUP Vagrant destroy $machine" ENDGROUP
  else
    Assert_Contains "$actual" "group Vagrant destroy $machine" endgroup
  fi
  Assert_Contains "$actual" "Vagrant file for machine $machine does not exist"
}