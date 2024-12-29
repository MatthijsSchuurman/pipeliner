#!/bin/bash

E2ETest_Examples_DotNet_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Root)/examples/dotnet/.pipelines/ci.local.sh examples/dotnet/app1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
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
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" warning "Running CI pipeline for examples/dotnet/app1"
    Assert_Contains "$actual" group "Docker Build ./.pipeliner/dotnet/Dockerfile"
    Assert_Contains "$actual" info "DotNet Test"
    Assert_Contains "$actual" group "Docker Run dotnet:runner dotnet test"
    Assert_Contains "$actual" info "DotNet Lint"
    Assert_Contains "$actual" group "Docker Run dotnet:runner dotnet format"
    Assert_Contains "$actual" info "DotNet Build"
    Assert_Contains "$actual" group "Docker Run dotnet:runner dotnet build"
    Assert_Contains "$actual" group "Docker Build Dockerfile examples/dotnet/app1"
    Assert_Contains "$actual" info "CI pipline for examples/dotnet/app1 done"
  fi
}
