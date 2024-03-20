#!/bin/bash

source $(Files_Path_Pipeliner)/haskell/cabal.class.sh

UnitTest_Haskell_Cabal_Build() {
  # Given
  local actual=
  local exitCode=
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Cabal_Build $workdir)
  exitCode=$?

  # Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/dist/
  Assert_File_Exists $(Files_Path_Root)/$workdir/dist/helloworld

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" INFO "Haskell Build"
  else
    Assert_Contains "$actual" info "Haskell Build"
  fi
}

UnitTest_Haskell_Cabal_Test() {
  # Given
  local actual=
  local exitCode=
  local workdir="examples/haskell/app1"

  # When
  actual=$(Haskell_Cabal_Test $workdir)
  exitCode=$?

  echo "$actual"
  # Then
  Assert_Equal $exitCode 0
  Assert_File_Exists $(Files_Path_Root)/$workdir/test-report.txt
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/dist/

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" INFO "Haskell Test"
  else
    Assert_Contains "$actual" info "Haskell Test"
  fi

  # Clean
  rm $(Files_Path_Root)/$workdir/test-report.txt
}

# UnitTest_Haskell_Cabal_Lint() {
#   # Given
#   local actual=
#   local exitCode=
#   local workdir="examples/haskell/app1"

#   # When
#   actual=$(Haskell_Cabal_Lint $workdir)
#   exitCode=$?

#   # Then
#   Assert_Equal $exitCode 0
#   Assert_File_Exists $(Files_Path_Root)/$workdir/lint-report.html

#   if [ $(Environment_Platform) == "local" ]; then
#     Assert_Contains "$actual" INFO "Haskell Lint"
#   else
#     Assert_Contains "$actual" info "Haskell Lint"
#   fi

#   # Clean
#   rm $(Files_Path_Root)/$workdir/lint-report.html
# }