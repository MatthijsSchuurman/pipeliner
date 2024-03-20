#!/bin/bash

Haskell_Pipelines_Stage_Build() {
  local app=$1

  Haskell_Cabal_Build $app

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}