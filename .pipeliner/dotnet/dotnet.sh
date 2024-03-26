#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.sh

DotNet_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner dotnet "$workdir" "" "${commands[@]}"
}

DotNet_Build() {
  local workdir=$1

  Log_Info "DotNet Build"
  DotNet_Run "$workdir" "dotnet build"
}

DotNet_Test() {
  local workdir=$1

  Log_Info "DotNet Test"
  DotNet_Run "$workdir" "dotnet test --logger 'trx;LogFileName=../../test-report.xml'"
}

DotNet_Lint() {
  local workdir=$1

  Log_Info "DotNet Lint"
  DotNet_Run "$workdir" "dotnet format --verify-no-changes --report=lint-report.json"
}
