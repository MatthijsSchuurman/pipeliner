#!/bin/bash

source $(Files_Path_Pipeliner)/haskell/haskell.class.sh

UnitTest_Haskell_Dockerfile() {
  # Given
  local tools=("ls" "cabal")

  # When
  for tool in "${tools[@]}"; do
    Docker_Runner haskell "" "" "which $tool"
    exitCode=$?

    # Then
    Assert_Equal $exitCode 0
  done

  # When
  actual=$(Docker_Runner haskell "" "" "cabal --version")

  # Then
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"
}

UnitTest_Haskell_Run() {
  # Given
  local actual
  local exitCode
  local workdir="examples/haskell"

  # When
  actual=$(Haskell_Run $workdir "cabal --version")
  exitCode=$?

  # Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"

  # When
  actual=$(Haskell_Run $workdir "cabal --version" "ls -la")
  exitCode=$?

  # Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+" examples drwx
}

UnitTest_Haskell_Build() {
  # Given
  local actual
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Build $workdir)

  # Then
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/dist/
}