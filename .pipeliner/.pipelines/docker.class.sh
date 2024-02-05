#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/version.class.sh
source $(Files_Path_Pipeliner)/core/docker.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh

Pipeliner_Docker_Create_Image() {
  local package=$1

  Log_Info "Create Pipeliner Docker image"
  Docker_Build $(Files_Path_Pipeliner)/.pipelines/Dockerfile pipeliner:$(Version_Pipeliner_Full) package=$package
  if [ $? != 0 ]; then exit 1 ; fi
  Docker_Save pipeliner:$(Version_Pipeliner_Full) pipeliner-docker-$(Version_Pipeliner_Full).tar.xz
  if [ $? != 0 ]; then exit 1 ; fi

  Variables_Set dockerImage "$(Files_Path_Root)/pipeliner-docker-$(Version_Pipeliner_Full).tar.xz"
}