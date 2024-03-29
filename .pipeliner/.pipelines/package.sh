#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.sh
source $(Files_Path_Pipeliner)/core/environment.sh
source $(Files_Path_Pipeliner)/core/version.sh
source $(Files_Path_Pipeliner)/core/compression.sh
source $(Files_Path_Pipeliner)/core/variables.sh
source $(Files_Path_Pipeliner)/core/artifacts.sh
source $(Files_Path_Pipeliner)/core/vcs.sh

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
  rm -f "$buildDirectory/README.md" "$buildDirectory/LICENSE.md"

  Log_Info "Creating package"
  cd "$buildDirectory"
  Compression_Zip "$(Files_Path_Root)/$filename" ./
  local exitCode=$?
  cd - > /dev/null

  Log_Debug "Removing build directory"
  rm -rf "$buildDirectory"

  Artifacts_Move "$(Files_Path_Root)/$filename" "packages/$filename"

  Variables_Set package "$(Artifacts_Directory)/packages/$filename" #bit of an assumption here
  Log_Debug "Package: $(Variables_Get package)"
  return $exitCode
}