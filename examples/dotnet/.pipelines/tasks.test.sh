#!/bin/bash

IntegrationTest_Examples_DotNet_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(DotNet_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/dotnet/app1 examples/dotnet/app2
}

IntegrationTest_Examples_DotNet_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

  VCS_Affected_Directories() { #mock
    echo "examples/dotnet/app1"
  }

  #When
  local actual=$(DotNet_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/dotnet/app1
  Assert_Not_Contains "$actual" examples/dotnet/app2
}


IntegrationTest_Examples_DotNet_Pipelines_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  DotNet_Pipelines_Build examples/dotnet/app1

  #Then
  actual=$(Docker_List examples/dotnet/app1:latest)
  Assert_Contains "$actual" "examples/dotnet/app1" "latest"

  actual=$(Docker_Run examples/dotnet/app1:latest "" "" "dotnet --info")
  Assert_Contains "$actual" Version 8.0

  Docker_Run examples/dotnet/app1:latest "" "" "test -f /home/app/work"
  Assert_Equal $? 0
}



IntegrationTest_Examples_DotNet_Pipelines_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  DotNet_Pipelines_Test examples/dotnet/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/lint-report.json

  #Clean
  rm $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  rm $(Files_Path_Root)/examples/dotnet/app1/lint-report.json
}
