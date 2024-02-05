#!/bin/bash

source $(Files_Path_Pipeliner)/node/npm.class.sh

UnitTest_NPM_Run_Install() {
  #Given
  local workdir=examples/node/app1

  #When
  Node_NPM_Install $workdir

  #Then
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/node_modules/
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/node_modules/mocha/

  #Clean
  rm -rf $(Files_Path_Root)/$workdir/node_modules/
}

UnitTest_NPM_Run_Install_Production() {
  #Given
  local workdir=examples/node/app1

  #When
  Node_NPM_Install $workdir true

  #Then
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/node_modules/
  Assert_Not_Directory_Exists $(Files_Path_Root)/$workdir/node_modules/mocha/

  #Clean
  rm -rf $(Files_Path_Root)/$workdir/node_modules/
}

UnitTest_NPM_Run_Test() {
  #Given
  local workdir=examples/node/app1

  #When
  Node_NPM_Test $workdir

  #Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/test-report.json

  #Clean
  rm $(Files_Path_Root)/$workdir/test-report.json
}

UnitTest_NPM_Run_Lint() {
  #Given
  local workdir=examples/node/app1

  #When
  Node_NPM_Lint $workdir

  #Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/lint-report.json

  #Clean
  rm $(Files_Path_Root)/$workdir/lint-report.json
}