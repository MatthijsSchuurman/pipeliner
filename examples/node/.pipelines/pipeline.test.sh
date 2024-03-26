#!/bin/bash

IntegrationTest_Examples_Node_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  local actual=$(Node_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/node/app1 examples/node/app2
}

IntegrationTest_Examples_Node_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  VCS_Affected_Directories() { #mock
    echo "examples/node/app1"
  }

  #When
  local actual=$(Node_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/node/app1
  Assert_Not_Contains "$actual" examples/node/app2
}