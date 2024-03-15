#!/bin/bash

source $(Files_Path_Pipeliner)/haskell/cabal.class.sh

UnitTest_Haskell_Cabal_Build() {
  # Given
  local actual
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Cabal_Build $workdir)

  # Then
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/dist/
}

UnitTest_Haskell_Cabal_Test() {
  # Given
  local actual
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Cabal_Test $workdir)

  # Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/test-report.xml
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/test/bin/

  # Clean
  rm $(Files_Path_Root)/$workdir/test-report.xml
}

UnitTest_Haskell_Cabal_Lint() {
  # Given
  local actual
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Cabal_Lint $workdir)

  # Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/lint-report.json

  # Clean
  rm $(Files_Path_Root)/$workdir/lint-report.json
}