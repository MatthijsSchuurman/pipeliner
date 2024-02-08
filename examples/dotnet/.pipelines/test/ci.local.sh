#!/bin/bash

E2ETest_Examples_DotNet_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  source $(Files_Path_Root)/examples/dotnet/.pipelines/ci.local.sh examples/dotnet/app1 > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Docker Install"
  Assert_Contains "$actual" "WARNING Running CI pipeline for examples/dotnet/app1"
  Assert_Contains "$actual" "GROUP Docker Build ./.pipeliner/dotnet/Dockerfile"
  Assert_Contains "$actual" "INFO DotNet Test"
  Assert_Contains "$actual" "GROUP Docker Run dotnet:runner dotnet test"
  Assert_Contains "$actual" "INFO DotNet Lint"
  Assert_Contains "$actual" "GROUP Docker Run dotnet:runner dotnet format"
  Assert_Contains "$actual" "INFO DotNet Build"
  Assert_Contains "$actual" "GROUP Docker Run dotnet:runner dotnet build"
  Assert_Contains "$actual" "GROUP Docker Build Dockerfile examples/dotnet/app1"
  Assert_Contains "$actual" "INFO CI pipline for examples/dotnet/app1 done"
}