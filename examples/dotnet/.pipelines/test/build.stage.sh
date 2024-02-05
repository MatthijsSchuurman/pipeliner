#!/bin/bash

IntegrationTest_Examples_DotNet_Stage_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  DotNet_Pipelines_Stage_Build examples/dotnet/app1

  #Then
  actual=$(Docker_List examples/dotnet/app1:latest)
  Assert_Contains "$actual" "examples/dotnet/app1" "latest"
}
