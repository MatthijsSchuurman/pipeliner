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

  Assert_Match "$actual" "unit Test report: .+\.txt"
  Assert_Match "$actual" "integration Test report: .+\.txt"

  local unitTestReport=$(echo "$actual" | grep --only-matching --max-count=1 "unit Test report: .*\.txt" | sed -E "s/unit Test report: (.+\.txt)/\1/")
  local integrationTestReport=$(echo "$actual" | grep --only-matching --max-count=1 "integration Test report: .*\.txt" | sed -E "s/integration Test report: (.+\.txt)/\1/")

  Assert_File_Exists "$unitTestReport"
  Assert_File_Exists "$integrationTestReport"
}