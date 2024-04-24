#!/bin/bash

IntegrationTest_Examples_Haskell_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(Haskell_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/haskell/app1 examples/haskell/app2
}

IntegrationTest_Examples_Haskell_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

  VCS_Affected_Directories() { #mock
    echo "examples/haskell/app1"
  }

  #When
  local actual=$(Haskell_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/haskell/app1
  Assert_Not_Contains "$actual" examples/haskell/app2
}


IntegrationTest_Examples_Haskell_Pipelines_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Haskell_Pipelines_Build examples/haskell/app1

  #Then
  actual=$(Docker_List examples/haskell/app1:latest)
  Assert_Contains "$actual" "examples/haskell/app1" "latest"

  Docker_Run examples/haskell/app1:latest "" "" "test -f /home/app/helloworld"
  Assert_Equal $? 0
}


IntegrationTest_Examples_Haskell_Pipelines_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Haskell_Pipelines_Test examples/haskell/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/haskell/app1/test-report.txt
  #Assert_File_Exists $(Files_Path_Root)/examples/haskell/app1/lint-report.html

  #Clean
  rm $(Files_Path_Root)/examples/haskell/app1/test-report.txt
  #rm $(Files_Path_Root)/examples/haskell/app1/lint-report.html
}
