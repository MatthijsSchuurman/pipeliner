#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

Node_Run() {
  local workdir=$1
  shift 1
  local commands=("$@")

  Docker_Runner node "$workdir" "npm_config_cache=/work/.npm/cache/" "${commands[@]}"
}