#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/vagrant.class.sh
source $(Files_Path_Pipeliner)/core/utils/packages.class.sh

UnitTest_Vagrant_Directory() {
  #Given

  #When
  local actual=$(Vagrant_Directory)

  #Then
  Assert_Equal "$actual" "$(Files_Path_Root)/.vagrant"
}

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

UnitTest_Vagrant_Up() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local machine=default

  #When
  actual=$(Vagrant_Up $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Bringing machine 'default' up with 'virtualbox' provider..."
}

UnitTest_Vagrant_Up_Fail() {
  #Given
  local actual=
  local exitCode=
  local machine=unknown

  #When
  actual=$(Vagrant_Up $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" "Vagrant file for machine $machine does not exist"
}

UnitTest_Vagrant_Halt() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=
  local machine=default

  #When
  actual=$(Vagrant_Halt $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "==> default: Attempting graceful shutdown of VM..."
}

UnitTest_Vagrant_Halt_Fail() {
  #Given
  local actual=
  local exitCode=
  local machine=unknown

  #When
  actual=$(Vagrant_Halt $machine)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
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
  Assert_Contains "$actual" "Vagrant file for machine $machine does not exist"
}