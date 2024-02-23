#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

JVM_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner jvm "$workdir" "" "${commands[@]}"
}