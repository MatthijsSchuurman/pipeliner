#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh

Artifacts_Directory() {
  local directory=

  case $(Environment_Platform) in
    "azure")
      directory=$BUILD_ARTIFACTSTAGINGDIRECTORY
      ;;
    "local")
      directory="$(Files_Path_Root)/artifacts"
      ;;
    *)
      Log_Error "Artifacts for $(Environment_Platform) platform is not supported" >&2
      exit 1
    ;;
  esac

  if [ ! -d "$directory" ]; then
    mkdir -p "$directory"
  fi

  echo "$directory"
}

Artifacts_Write() {
  local fileName=$1
  local content=$2

  Log_Info "Writing artifact '$fileName'"
  echo "$content" > "$(Artifacts_Directory)/$fileName"
}

Artifacts_Delete() {
  local fileName=$1

  if [ ! -f "$(Artifacts_Directory)/$fileName" ]; then
    Log_Warning "Artifact '$fileName' does not exist"
    return 1
  fi

  Log_Info "Deleting artifact '$fileName'"
  rm "$(Artifacts_Directory)/$fileName"
}