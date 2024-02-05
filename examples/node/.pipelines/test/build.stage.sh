#!/bin/bash

IntegrationTest_Examples_Node_Stage_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  Node_Pipelines_Stage_Build examples/node/app1

  #Then
  actual=$(Docker_List examples/node/app1:latest)
  Assert_Contains "$actual" "examples/node/app1" "latest"
}
