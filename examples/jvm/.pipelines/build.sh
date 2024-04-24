#!/bin/bash

JVM_Pipelines_Build() {
  local app=$1

  JVM_Gradle_Clean $app
  JVM_Gradle_Build $app

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}