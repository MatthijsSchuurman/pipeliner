#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

Node_Run() {
  local command=$1
  local workdir=$2

  Docker_Runner node "$workdir" "npm_config_cache=/work/.npm/cache/" "$command"
}