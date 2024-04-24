#!/bin/bash

IntegrationTest_Examples_Node_Build() {
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
