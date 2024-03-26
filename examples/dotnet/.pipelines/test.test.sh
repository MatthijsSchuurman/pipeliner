#!/bin/bash

IntegrationTest_Examples_DotNet_Pipelines_Stage_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  DotNet_Pipelines_Stage_Test examples/dotnet/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/lint-report.json

  #Clean
  rm $(Files_Path_Root)/examples/dotnet/app1/test-report.xml
  rm $(Files_Path_Root)/examples/dotnet/app1/lint-report.json
}
