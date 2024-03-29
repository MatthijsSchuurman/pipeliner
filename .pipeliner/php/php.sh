#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.sh

PHP_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner php "$workdir" "" "${commands[@]}"
}

PHP_Build() {
  local workdir=$1

  Log_Error "PHP Build not implemented"
  return 1
}

PHP_Lint() {
  local workdir=$1

  Log_Info "PHP Lint"
  PHP_Run "$workdir" "/bin/sh -c 'php -l */*.php' > lint-report.txt"
}
