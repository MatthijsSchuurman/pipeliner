#!/bin/bash

IntegrationTest_Examples_Node_Pipelines_Stage_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Node_Pipelines_Stage_Test examples/node/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/test-report.json
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/lint-report.json

  #Clean
  rm $(Files_Path_Root)/examples/node/app1/test-report.json
  rm $(Files_Path_Root)/examples/node/app1/lint-report.json
}
