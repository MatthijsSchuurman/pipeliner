#!/bin/bash

E2ETest_Test_Type() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --type unit --include core/test/test.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner core utils test"
  Assert_Match "$actual" "Test Title: .+OK"
  Assert_Match "$actual" "Example: .+OK"
  Assert_Match "$actual" "Example: .+SKIP"

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --type integration --include core/test/test.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Test Title: .+SKIP"
  Assert_Match "$actual" "Example: .+OK"
  Assert_Match "$actual" "Example: .+SKIP"

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --type e2e --include core/test/test.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Test Title: .+SKIP"
  Assert_Match "$actual" "Example: .+SKIP"
  Assert_Match "$actual" "Example: .+OK"
}

E2ETest_Test_Include() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --type dontrunanytests --include colors.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner core utils colors"
  Assert_Match "$actual" "Color Red: .+SKIP"
}

E2ETest_Test_Exclude() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --type dontrunanytests --exclude colors.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner core utils files"
  Assert_Match "$actual" "Files Path Pipeliner: .+SKIP"
  Assert_Not_Match "$actual" "Color Red: .+SKIP"
}

#Doesn't work because --watch running independently
# E2ETest_Test_Watch() {
#   #Given
#   local actual=
#   local exitCode=

#   #When
#   E2ETest_Test_Watch_thread(){
#     sleep 1
#     touch $(Files_Path_Pipeliner)/core/colors.sh
#   }

#   E2ETest_Test_Watch_thread &
#   actual=$($(Files_Path_Pipeliner)/test.sh --watch)
#   exitCode=$?

#   #Then
#   Assert_Equal $exitCode 0
#   Assert_Contains "$actual" "Watching for changes in $(Files_Path_Root)"
#   Assert_Contains "$actual" "Re-running tests for $(Files_Path_Pipeliner)/core/colors.sh"
#   Assert_Contains "$actual" "Pipeliner core utils colors"
#   Assert_Match "$actual" "Color Red: .+OK"
# }

E2ETest_Test_Arguments() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --help)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Usage:" "test.sh" "options"
  Assert_Contains "$actual" "--watch" "Watch for changes and re-run tests"
  Assert_Contains "$actual" "--type" "Test type (unit,integration,e2e)"
  Assert_Contains "$actual" "--include" "Include pattern"
  Assert_Contains "$actual" "--exclude" "Exclude pattern"
  Assert_Contains "$actual" "--help" "Show usage information"
  Assert_Contains "$actual" "--version" "Show version information"
  Assert_Contains "$actual" "-w" "--watch"
  Assert_Contains "$actual" "-t" "--type"
  Assert_Contains "$actual" "-i" "--include"
  Assert_Contains "$actual" "-e" "--exclude"

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --version)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner $(Version_Pipeliner)"
}

E2ETest_Test_Arguments_Fail() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/test.sh --unknown 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" "Unknown argument: --unknown"
}