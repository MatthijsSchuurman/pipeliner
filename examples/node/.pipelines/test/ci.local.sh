#!/bin/bash

E2ETest_Examples_Node_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File).log
  source $(Files_Path_Root)/examples/node/.pipelines/ci.local.sh examples/node/app1 > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Docker Install"
  Assert_Contains "$actual" "WARNING Running CI pipeline for examples/node/app1"
  Assert_Contains "$actual" "GROUP Docker Build ./.pipeliner/node/Dockerfile"
  Assert_Contains "$actual" "INFO NPM Test"
  Assert_Contains "$actual" "GROUP Docker Run node:runner npm test"
  Assert_Contains "$actual" "INFO NPM Lint"
  Assert_Contains "$actual" "GROUP Docker Run node:runner npm run lint"
  Assert_Contains "$actual" "INFO NPM Install packages"
  Assert_Contains "$actual" "GROUP Docker Run node:runner npm install --omit=dev"
  Assert_Contains "$actual" "GROUP Docker Build Dockerfile examples/node/app1"
  Assert_Contains "$actual" "INFO CI pipline for examples/node/app1 done"
}