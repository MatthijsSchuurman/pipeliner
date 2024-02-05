#!/bin/bash

E2ETest_Init() {
  #Given
  local actual=
  local exitCode=

  #When
  source $(Files_Path_Pipeliner)/init.sh > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Docker Install"
  Assert_Contains "$actual" "Docker version"
  Assert_Contains "$actual" ENDGROUP

  Assert_Function Docker_Install
  Assert_Function Log_Info
  Assert_Function Version_Pipeliner
}