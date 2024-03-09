#!/bin/bash

E2ETest_Pipeliner_Pipeline_CI() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/.pipelines/ci.local.sh 2>&1)
  exitCode=$?

  echo "$actual"

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Pipeliner core compression"
  Assert_Match "$actual" "Compression Zip.*OK"

  Assert_Match "$actual" "unitTestReport=.+\.txt"
  Assert_Match "$actual" "integrationTestReport=.+\.txt"
  Assert_Match "$actual" "e2eTestReport=.+\.txt"

  local unitTestReport=$(echo "$actual" | grep -Pom 1 "unitTestReport=\]?.+\.txt" | sed -E "s/unitTestReport=\]?//")
  local integrationTestReport=$(echo "$actual" | grep -Pom 1 "integrationTestReport=\]?.+\.txt" | sed -E "s/integrationTestReport=\]?//")
  local e2eTestReport=$(echo "$actual" | grep -Pom 1 "e2eTestReport=\]?.+\.txt" | sed -E "s/e2eTestReport=\]?//")

  Assert_File_Exists "$unitTestReport"
  Assert_File_Exists "$integrationTestReport"
  Assert_File_Exists "$e2eTestReport"
}