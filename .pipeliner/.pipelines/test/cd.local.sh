#!/bin/bash

E2ETest_Pipeliner_Pipeline_CD() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  source $(Files_Path_Pipeliner)/.pipelines/cd.local.sh > $logFile 2>&1 #needs to use a unique filename so tests don't remove it
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Docker Install"

  Assert_Contains "$actual" "Creating package"
  Assert_Contains "$actual" "adding: .pipeliner/test.sh"
  Assert_Contains "$actual" "adding: examples/node/app1/test.js"
  Assert_Contains "$actual" "Removing build directory"
  Assert_Function Pipeliner_Package_Create

  local package=$(Variables_Get package)
  Assert_File_Exists "$package"

  local dockerImage=$(echo $(Variables_Get package) | sed -E "s/(pipeliner)-(.+)\.zip/\1-docker-\2.tar.xz/")
  Assert_File_Exists "$dockerImage"

  #Download pipeliner from docker image
  docker stop pipeliner_e2etest > /dev/null 2>&1
  docker rm --force pipeliner_e2etest > /dev/null 2>&1
  docker run --name pipeliner_e2etest --detach=true --publish 127.0.0.1:8088:80 pipeliner:$(Version_Pipeliner_Full)
  Assert_Equal $? 0
  wget --quiet --content-disposition http://127.0.0.1:8088/pipeliner.zip #will redirect to pipeliner-$(Version_Pipeliner_Full).zip
  Assert_Equal $? 0
  wget --quiet --content-disposition http://127.0.0.1:8088/install.sh
  Assert_Equal $? 0
  docker stop pipeliner_e2etest > /dev/null 2>&1
  docker rm --force pipeliner_e2etest > /dev/null 2>&1

  Assert_File_Exists "$package.1" #auto-renamed by wget

  #Clean
  rm "$package"
  rm "$dockerImage"
  rm "$package.1"
  rm "install.sh"
}