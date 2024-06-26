#!/bin/bash

PHP_Pipelines_Build() {
  local app=$1

  PHP_Composer_Install $app prod

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}