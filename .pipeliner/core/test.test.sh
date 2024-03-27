#!/bin/bash

source $(Files_Path_Pipeliner)/core/test.sh

UnitTest_Example() {
  #Given

  #When

  #Then
  Assert_Empty
}
IntegrationTest_Example() {
  #Given

  #When

  #Then
  Assert_Empty
}
E2ETest_Example() {
  #Given

  #When

  #Then
  Assert_Empty
}

UnitTest_Example_Skip() {
  #Given

  #When
  exit 255 #skip

  #Then
}

UnitTest_Test__Title() {
  #Given
  local file="$(Files_Path_Pipeliner)/core/test.test.sh"

  #When
  local title=$(Test__Title $file)

  #Then
  Assert_Equal "$title" "Pipeliner core test"
}

UnitTest_Test__Name() {
  #Given
  local test="UnitTest_Test__Name"

  #When
  local name=$(Test__Name $test)

  #Then
  Assert_Equal "$name" "Test Name"
}

UnitTest_Test_Execute() {
  #Given
  local test="UnitTest_Example"
  local actual=
  local exitCode=

  #When
  actual=$(Test_Execute $test)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "OK"
}
UnitTest_Test_Execute_Fail() {
  #Given
  local test="UnitTest_Example"
  local actual=
  local exitCode=

  UnitTest_Example() { #mock
    Assert_Not_Empty
  }

  #When
  actual=$(Test_Execute $test)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "FAIL"
}

UnitTest_Test_Run() {
  #Given
  local type=unit,integration,e2e
  local include=core/misc.test.sh
  local exclude=

  local actual=
  local exitCode=

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "implode: .*OK.*"
  Assert_Match "$actual" "explode: .*OK.*"
  Assert_Match "$actual" "map: .*OK.*"
  Assert_Match "$actual" "reduce: .*OK.*"

  Assert_Match "$actual" "9.* passed / 9 total"
}

UnitTest_Test_Run_Type() {
  #Given
  local type=integration,e2e #don't include unit tests to avoid recursion
  local include=core/test.test.sh
  local exclude=

  local actual=
  local exitCode=

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Example.*: .*OK.*"
  Assert_Match "$actual" "Test Run.*: .*SKIP.*"

  Assert_Match "$actual" "2.* passed / .*11.* skipped / 13 total"


  #Given
  local type=e2e #don't include unit tests to avoid recursion
  local include=core/test.test.sh
  local exclude=

  local actual=
  local exitCode=

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Example.*: .*OK.*"
  Assert_Match "$actual" "Test Run.*: .*SKIP.*"
  Assert_Match "$actual" "Example.*: .*SKIP.*"

  Assert_Match "$actual" "1.* passed / .*12.* skipped / 13 total"


  #Given
  local type=unknown #don't include unit tests to avoid recursion
  local include=core/test.test.sh
  local exclude=

  local actual=
  local exitCode=

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "0.* passed / .*13.* skipped / 13 total"
}

UnitTest_Test_Run_Exclude() {
  #Given
  local type=unit,integration,e2e
  local include=core/misc.test.sh
  local exclude=core/misc.test.sh

  local actual=
  local exitCode=

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "0.* passed / 0 total"


  #Given
  local type=unit
  local include=sion
  local exclude=compression

  local actual=
  local exitCode=

  UnitTest_Example() { #mock
    Assert_Empty
  }

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Version"
  Assert_Not_Contains "$actual" "Compression"
}

UnitTest_Test_Run_Fail() {
  #Given
  local type=unit,integration,e2e
  local include=core/misc.test.sh
  local exclude=

  local actual=
  local exitCode=

  Test_Execute() { #mock
    Color_Red "FAIL" ; echo
    return 1
  }

  #When
  actual=$(Test_Run $type $include $exclude)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "implode: .*FAIL.*"
  Assert_Match "$actual" "explode: .*FAIL.*"
  Assert_Match "$actual" "map: .*FAIL.*"
  Assert_Match "$actual" "reduce: .*FAIL.*"
  Assert_Match "$actual" "0.* passed / .*9.* failed / 9 total"
}

UnitTest_Test_Statistics() {
  #Given
  local actual=

  #When
  actual=$(Test_Statistics)

  #Then
  Assert_Contains "$actual" /examples /.pipeliner Total
  Assert_Match "$actual" "Unit tests: .*[0-9]+"
  Assert_Match "$actual" "Integration tests: .*[0-9]+"
  Assert_Match "$actual" "E2E tests: .*[0-9]+"
  Assert_Match "$actual" "Total tests: .*[0-9]+"
}