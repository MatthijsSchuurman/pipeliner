#!/bin/bash

Node_Pipelines_Stage_Build() {
  local app=$1

  Node_NPM_Install $app prod

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  cd "$curpath"
}