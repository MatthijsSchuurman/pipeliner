#!/bin/bash

JVM_Pipelines_Stage_Build() {
  local app=$1

  JVM_Gradle_Build $app prod

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  cd "$curpath"
}