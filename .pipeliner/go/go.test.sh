#!/bin/bash

source $(Files_Path_Pipeliner)/go/go.sh

UnitTest_Go_Dockerfile() {
  #Given
  local actual=
  local exitCode=
  local tools=(ls go)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner go "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done

  #When
  actual=$(Docker_Runner go "" "" "go version")

  #Then
  Assert_Match "$actual" "go1\.23\.[0-9]+"
}

UnitTest_Go_Run() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/go

  #When
  actual=$(Go_Run $workdir "go version" "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "go[0-9]+\.[0-9]+\.[0-9]+" examples drwx
}

UnitTest_Go_Mod() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/go/test1
  mkdir -p $(Files_Path_Root)/$workdir

  #When
  actual=$(Go_Mod $workdir "init example.com/test1")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/
  Assert_File_Exists $(Files_Path_Root)/$workdir/go.mod

  #Cleanup
  rm -rf $(Files_Path_Root)/$workdir
}

UnitTest_Go_Build() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/go/app1

  #When
  actual=$(Go_Build $workdir)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_File_Exists $(Files_Path_Root)/$workdir/app
}

UnitTest_Go_Test() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/go/app1

  #When
  actual=$(Go_Test $workdir)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_File_Exists $(Files_Path_Root)/$workdir/coverage.out
}

UnitTest_Go_Lint() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/go/app1

  #When
  actual=$(Go_Lint $workdir)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
}
