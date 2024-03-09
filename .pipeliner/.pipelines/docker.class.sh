#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/version.class.sh
source $(Files_Path_Pipeliner)/core/docker.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh
source $(Files_Path_Pipeliner)/core/artifacts.class.sh

Pipeliner_Docker_Create_Image() {
  local package=$1
  local filename="pipeliner-docker-$(Version_Pipeliner_Full).tar.xz"

  Log_Info "Create Pipeliner Docker image"

  local packageLocal=$(Files_Path_Root)/$(basename $package)
  cp "$package" "$packageLocal" # Copy package to root folder so docker is able to access it
  Docker_Build $(Files_Path_Pipeliner)/.pipelines/Dockerfile pipeliner:$(Version_Pipeliner_Full) package=$packageLocal
  if [ $? != 0 ]; then exit 1 ; fi
  rm -f "$packageLocal"

  Docker_Save pipeliner:$(Version_Pipeliner_Full) "$(Files_Path_Root)/$filename"
  if [ $? != 0 ]; then exit 1 ; fi

  Artifacts_Move "$(Files_Path_Root)/$filename" "packages/$filename"

  Variables_Set dockerImage "$(Artifacts_Directory)/packages/$filename"
}