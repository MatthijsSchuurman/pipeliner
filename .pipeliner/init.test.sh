#!/bin/bash

E2ETest_Init() {
  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  source $(Files_Path_Pipeliner)/init > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
  fi


  Assert_Function Packages_Prerequisites
  Assert_Function Log_Info
  Assert_Function Version_Pipeliner
}