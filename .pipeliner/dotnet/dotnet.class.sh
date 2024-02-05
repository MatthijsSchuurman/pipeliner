#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

DotNet_Run() {
  local command=$1
  local workdir=$2

  Docker_Runner dotnet "$command" "$workdir"
}

DotNet_Build() {
  local workdir=$1

  Log_Info "DotNet Build"
  DotNet_Run "dotnet build" "$workdir"
}

DotNet_Test() {
  local workdir=$1

  Log_Info "DotNet Test"
  DotNet_Run "dotnet test --logger trx;LogFileName=../../test-report.xml" "$workdir"
}

DotNet_Lint() {
  local workdir=$1

  Log_Info "DotNet Lint"
  DotNet_Run "dotnet format --verify-no-changes --report=lint-report.json" "$workdir"
}
