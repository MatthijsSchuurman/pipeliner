#!/bin/bash

source $(Files_Path_Pipeliner)/node/node.class.sh

Node_NPM_Install() {
  local workdir=$1
  local production=$2

  Log_Info "NPM Install packages"
  if [ "$production" ]; then
    Node_Run "$workdir" "npm install --omit=dev"
  else
    Node_Run "$workdir" "npm install"
  fi
}

Node_NPM_Test() {
  local workdir=$1

  Log_Info "NPM Test"
  Node_Run "$workdir" "npm install" "npm test"
}

Node_NPM_Lint() {
  local workdir=$1

  Log_Info "NPM Lint"
  Node_Run "$workdir" "npm install" "npm run lint"
}