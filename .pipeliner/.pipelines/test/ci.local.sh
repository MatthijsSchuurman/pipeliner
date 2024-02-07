#!/bin/bash

E2ETest_Pipeliner_Pipeline_CI() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  source $(Files_Path_Pipeliner)/.pipelines/ci.local.sh > tmp.ci.log 2>&1 #needs to use a unique filename so tests don't remove it
  exitCode=$?
  actual=$(cat tmp.ci.log)
  rm tmp.ci.log

  #Then
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Pipeliner core compression"
  Assert_Match "$actual" "Compression Zip.*OK"

  local unitTestReport=$(Variables_Get unitTestReport)
  Assert_File_Exists "$unitTestReport"

  local integrationTestReport=$(Variables_Get integrationTestReport)
  Assert_File_Exists "$integrationTestReport"

  local e2eTestReport=$(Variables_Get e2eTestReport)
  Assert_File_Exists "$e2eTestReport"

  #Clean
  rm "$unitTestReport" "$integrationTestReport" "$e2eTestReport"
}