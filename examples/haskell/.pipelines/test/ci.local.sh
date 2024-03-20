#!/bin/bash

E2ETest_Examples_Haskell_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Root)/examples/haskell/.pipelines/ci.local.sh examples/haskell/app1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
  Assert_Contains "$actual" "WARNING Running CI pipeline for examples/haskell/app1"
  Assert_Contains "$actual" "GROUP Docker Build ./.pipeliner/haskell/Dockerfile"
  Assert_Contains "$actual" "INFO Haskell Test"
  Assert_Contains "$actual" "GROUP Docker Run haskell:runner cabal test"
  Assert_Contains "$actual" "INFO Haskell Lint"
  Assert_Contains "$actual" "GROUP Docker Run haskell:runner hlint"
  Assert_Contains "$actual" "INFO Haskell Build"
  Assert_Contains "$actual" "GROUP Docker Run haskell:runner cabal build"
  Assert_Contains "$actual" "GROUP Docker Build Dockerfile examples/haskell/app1"
  Assert_Contains "$actual" "INFO CI pipline for examples/haskell/app1 done"
}