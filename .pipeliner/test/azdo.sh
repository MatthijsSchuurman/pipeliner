#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/vagrant.class.sh
source $(Files_Path_Pipeliner)/core/utils/packages.class.sh

E2ETest_AZDO_Agent_Start() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=

  Vagrant_Halt azdo

  #When
  actual=$($(Files_Path_Pipeliner)/azdo.sh agent start)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Vagrant up azdo" "vagrant ssh" ENDGROUP


  #When
  actual=$($(Files_Path_Pipeliner)/azdo.sh agent start)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Not_Contains "$actual" GROUP azdo ssh ENDGROUP
}

E2ETest_AZDO_Agent_Command() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/azdo.sh agent command "pwd ; ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "/home/vagrant" drwx
}

E2ETest_AZDO_Agent_Stop() {
  if ! Packages_Installed vagrant ; then
    Log_Warning "Skipping test because vagrant is not installed"
    exit 255
  fi

  #Given
  local actual=
  local exitCode=

  Vagrant_Up azdo

  #When
  actual=$($(Files_Path_Pipeliner)/azdo.sh agent stop)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Vagrant halt azdo" ENDGROUP
}