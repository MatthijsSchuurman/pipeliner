#!/bin/bash

IntegrationTest_Examples_Node_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(Node_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/node/app1 examples/node/app2
}

IntegrationTest_Examples_Node_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

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


IntegrationTest_Examples_Node_Pipelines_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Node_Pipelines_Build examples/node/app1

  #Then
  actual=$(Docker_List examples/node/app1:latest)
  Assert_Contains "$actual" "examples/node/app1" "latest"

  actual=$(Docker_Run examples/node/app1:latest "" "" "node --version")
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"

  Docker_Run examples/node/app1:latest "" "" "test -f /home/node/app/package.json"
  Assert_Equal $? 0
  Docker_Run examples/node/app1:latest "" "" "test -f /home/node/app/src/main.js"
  Assert_Equal $? 0
  Docker_Run examples/node/app1:latest "" "" "test -d /home/node/app/node_modules/"
  Assert_Equal $? 0
  Docker_Run examples/node/app1:latest "" "" "test -d /home/node/app/node_modules/mocha"
  Assert_Equal $? 1
}


IntegrationTest_Examples_Node_Pipelines_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  Node_Pipelines_Test examples/node/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/test-report.json
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/lint-report.json

  #Clean
  rm $(Files_Path_Root)/examples/node/app1/test-report.json
  rm $(Files_Path_Root)/examples/node/app1/lint-report.json
}