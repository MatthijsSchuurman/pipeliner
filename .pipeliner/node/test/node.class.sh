#!/bin/bash

source $(Files_Path_Pipeliner)/node/node.class.sh

UnitTest_Node_Dockerfile() {
  #Given
  local tools=(ls)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner node "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done
}

UnitTest_Node_Run() {
  #Given
  local actual=
  local workdir=examples/node

  #When
  actual=$(Node_Run "npm --version" $workdir)

  #Then
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"
}
