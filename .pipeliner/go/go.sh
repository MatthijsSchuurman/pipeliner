#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.sh

Go_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner go "$workdir" "" "${commands[@]}"
}

Go_Mod() {
  local workdir=$1
  shift 1

  Log_Info "Go Mod"
  Go_Run "$workdir" "go mod $@"
}

Go_Build() {
  local workdir=$1

  Log_Info "Go Build"
  Go_Run "$workdir" "go build ./"
}

Go_Test() {
  local workdir=$1

  Log_Info "Go Test"
  Go_Run "$workdir" "go test -v -coverprofile=coverage.out ./..."
}

Go_Lint() {
  local workdir=$1

  Log_Info "Go Lint"
  Go_Run "$workdir" "go fmt ./..."
}
