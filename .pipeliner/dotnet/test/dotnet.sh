#!/bin/bash

source $(Files_Path_Pipeliner)/dotnet/dotnet.sh

UnitTest_DotNet_Dockerfile() {
  #Given
  local tools=(ls dotnet)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner dotnet "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done


  #When
  actual=$(Docker_Runner dotnet "" "" "dotnet --version")

  #Then
  Assert_Match "$actual" "8\.0\.[0-9]+"
}

UnitTest_DotNet_Run() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/dotnet

  #When
  actual=$(DotNet_Run $workdir "dotnet --version")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"


  #When
  actual=$(DotNet_Run $workdir "dotnet --version" "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+" examples drwx
}

UnitTest_DotNet_Build() {
  #Given
  local actual=
  local workdir=examples/dotnet/app1

  #When
  actual=$(DotNet_Build $workdir)

  #Then
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/src/bin/
}

UnitTest_DotNet_Test() {
  #Given
  local actual=
  local workdir=examples/dotnet/app1

  #When
  actual=$(DotNet_Test $workdir)

  #Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/test-report.xml
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/test/bin/

  #Clean
  rm $(Files_Path_Root)/$workdir/test-report.xml
}

UnitTest_DotNet_Lint() {
  #Given
  local actual=
  local workdir=examples/dotnet/app1

  #When
  actual=$(DotNet_Lint $workdir)

  #Then
  Assert_File_Exists $(Files_Path_Root)/$workdir/lint-report.json

  #Clean
  rm $(Files_Path_Root)/$workdir/lint-report.json
}