#!/bin/bash

source $(Files_Path_Pipeliner)/node/node.class.sh

UnitTest_Node_Dockerfile() {
  #Given
  local tools=(ls node npm)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner node "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done


  #When
  actual=$(Docker_Runner node "" "" "node --version")

  #Then
  Assert_Match "$actual" "v19\.[0-9]+\.[0-9]+"
}

UnitTest_Node_Run() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/node

  #When
  actual=$(Node_Run $workdir "npm --version")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"

  #When
  actual=$(Node_Run $workdir "npm --version" "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]" examples drwx
}
