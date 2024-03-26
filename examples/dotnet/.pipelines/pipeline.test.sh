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