#!/bin/bash

IntegrationTest_Examples_Go_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(Go_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/go/app1 examples/go/app2
}

IntegrationTest_Examples_Go_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

  VCS_Affected_Directories() { #mock
    echo "examples/go/app1"
  }

  #When
  local actual=$(Go_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/go/app1
  Assert_Not_Contains "$actual" examples/go/app2
}


IntegrationTest_Examples_Go_Pipelines_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Go_Pipelines_Build examples/go/app1

  #Then
  actual=$(Docker_List examples/go/app1:latest)
  Assert_Contains "$actual" "examples/go/app1" "latest"

  actual=$(Docker_Run examples/go/app1:latest "" "" "ls -la")
  Assert_Contains "$actual" drwx

  Docker_Run examples/go/app1:latest "" "" "test -f /home/app/work"
  Assert_Equal $? 0
}



IntegrationTest_Examples_Go_Pipelines_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Go_Pipelines_Test examples/go/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/go/app1/coverage.out

  #Clean
  rm $(Files_Path_Root)/examples/go/app1/coverage.out
}
