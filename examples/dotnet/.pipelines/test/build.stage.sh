#!/bin/bash

IntegrationTest_Examples_DotNet_Stage_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  DotNet_Pipelines_Stage_Build examples/dotnet/app1

  #Then
  actual=$(Docker_List examples/dotnet/app1:latest)
  Assert_Contains "$actual" "examples/dotnet/app1" "latest"

  actual=$(Docker_Run examples/dotnet/app1:latest "" "" "dotnet --info")
  Assert_Contains "$actual" Version 8.0

  Docker_Run examples/dotnet/app1:latest "" "" "test -f /home/app/work"
  Assert_Equal $? 0
}
