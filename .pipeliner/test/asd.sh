#!/bin/bash

source $(Files_Path_Pipeliner)/asd.sh

UnitTest_LSASD() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(LSASD)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "README.md"
}

UnitTest_LSASD_Callback_Docker() {
  #Given
  local actual=
  local exitCode=
  local callback="Docker_Runner core '' ''"

  #When
  actual=$(LSASD_Callback "$callback")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "README.md"
}

UnitTest_LSASD_Callback_SSH() {
  #Given
  local actual=
  local exitCode=
  local callback="SSH_Run localhost?key=asd"

  #When
  actual=$(LSASD_Callback "$callback")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "tmp"
}

UnitTest_LSASD_Callback_Parallel() {
  #Given
  local actual=
  local exitCode=
  local callback="Parallel_Run 5"

  #When
  actual=$(LSASD_Callback "$callback")
  exitCode=$?
  echo "actual: $actual"

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "README.md"
}

UnitTest_LSASD_Docker() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(LSASD_Docker)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "README.md"
}

UnitTest_LSASD_SSH() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(LSASD_SSH)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "tmp"
}

UnitTest_LSASD_Parallel() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(LSASD_Parallel)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "README.md"
}