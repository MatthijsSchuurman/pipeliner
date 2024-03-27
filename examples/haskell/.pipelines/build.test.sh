#!/bin/bash

IntegrationTest_Examples_Haskell_Stage_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Haskell_Pipelines_Stage_Build examples/haskell/app1

  #Then
  actual=$(Docker_List examples/haskell/app1:latest)
  Assert_Contains "$actual" "examples/haskell/app1" "latest"

  Docker_Run examples/haskell/app1:latest "" "" "test -f /home/app/helloworld"
  Assert_Equal $? 0
}