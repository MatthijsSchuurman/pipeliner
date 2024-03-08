#!/bin/bash

E2ETest_Pipeliner_Pipeline_CI() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  local logFile=ci.local.log #don't use Files_Temp_File because temp directory is removed
  source $(Files_Path_Pipeliner)/.pipelines/ci.local.sh > $logFile 2>&1 #needs to use a unique filename so tests don't remove it
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  echo "$actual"

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Pipeliner core compression"
  Assert_Match "$actual" "Compression Zip.*OK"

  local unitTestReport=$(Variables_Get unitTestReport)
  Assert_File_Exists "$unitTestReport"

  local integrationTestReport=$(Variables_Get integrationTestReport)
  Assert_File_Exists "$integrationTestReport"

  local e2eTestReport=$(Variables_Get e2eTestReport)
  Assert_File_Exists "$e2eTestReport"
}