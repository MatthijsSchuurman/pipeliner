#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/docker.class.sh

UnitTest_Pipeliner_Docker_Create_Image() {
  #Given
  local actual=
  local exitCode=

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  local packageFile="$(Files_Path_Root)/pipeliner-$(Version_Pipeliner_Full).zip"
  local dockerImageFile="$(Files_Path_Root)/pipeliner-docker-$(Version_Pipeliner_Full).tar.xz"

  touch "$packageFile"

  #When
  Pipeliner_Docker_Create_Image "$packageFile" > tmp.log 2>&1
  actual=$(cat tmp.log)
  rm tmp.log
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" INFO "Create Pipeliner Docker image"
  else
    Assert_Contains "$actual" info "Create Pipeliner Docker image"
  fi

  Assert_File_Exists "$dockerImageFile"
  Assert_Match "$(Variables_Get dockerImage)" "$dockerImageFile"

  #Clean
  rm -f "$packageFile" "$dockerImageFile"
}