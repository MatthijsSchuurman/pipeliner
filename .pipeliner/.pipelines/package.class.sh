#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh
source $(Files_Path_Pipeliner)/core/version.class.sh
source $(Files_Path_Pipeliner)/core/compression.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh
source $(Files_Path_Pipeliner)/core/utils/vcs.class.sh

Pipeliner_Package_Filename() {
  local version=$(Version_Pipeliner_Full)

  echo "pipeliner-$version.zip"
}

Pipeliner_Package_Create() {
  local filename=$(Pipeliner_Package_Filename)
  local buildDirectory=$(Files_Path_Root)/build

  Log_Info "Preparing build directory"
  rm -rf "$buildDirectory"
  VCS_Clone_Directory "$(Files_Path_Root)" "$buildDirectory"
  rm -rf "$buildDirectory/.hg" "$buildDirectory/.git"
  rm -f "$buildDirectory/.hgignore" "$buildDirectory/.gitignore"

  Log_Info "Creating package"
  cd "$buildDirectory"
  Compression_Zip "$(Files_Path_Root)/$filename" ./
  local exitCode=$?
  cd - > /dev/null

  Log_Debug "Removing build directory"
  rm -rf "$buildDirectory"

  Variables_Set package "$(Files_Path_Root)/$filename"
  return $exitCode
}