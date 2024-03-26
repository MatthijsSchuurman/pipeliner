#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

Haskell_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner haskell "$workdir" "" "${commands[@]}"
}