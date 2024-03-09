#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/docker.class.sh

UnitTest_Pipeliner_Docker_Create_Image() {
  #Given
  local actual=
  local exitCode=

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }
  Artifacts_Directory() { #mock
    echo "artifacts-test"
  }

  rm -rf "$(Artifacts_Directory)"
  mkdir -p "$(Artifacts_Directory)"

  local packageFile="$(Artifacts_Directory)/pipeliner-$(Version_Pipeliner_Full).zip"
  touch "$packageFile"

  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Docker_Create_Image "$packageFile" > $logFile 2>&1
  actual=$(cat $logFile)
  rm $logFile
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" INFO "Create Pipeliner Docker image"
  else
    Assert_Contains "$actual" info "Create Pipeliner Docker image"
  fi

  Assert_File_Exists "$(Artifacts_Directory)/packages/pipeliner-docker-1.2.345-test.tar.xz"
  Assert_Match "$(Variables_Get dockerImage)" "$(Artifacts_Directory)/packages/pipeliner-docker-1.2.345-test.tar.xz"

  #Clean
  rm -rf "$(Artifacts_Directory)"
}