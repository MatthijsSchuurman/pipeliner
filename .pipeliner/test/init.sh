#!/bin/bash

E2ETest_Init() {
  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  source $(Files_Path_Pipeliner)/init.sh > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Install" ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Install" endgroup
  fi

  Assert_Contains "$actual" "Docker version"

  Assert_Function Docker_Install
  Assert_Function Log_Info
  Assert_Function Version_Pipeliner
}