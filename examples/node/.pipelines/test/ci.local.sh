#!/bin/bash

E2ETest_Examples_Node_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Root)/examples/node/.pipelines/ci.local.sh examples/node/app1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
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