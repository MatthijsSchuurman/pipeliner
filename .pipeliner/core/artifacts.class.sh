#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh

Artifacts_Directory() {
  local directory=

  case $(Environment_Platform) in
    "azure")
      directory=$(Files_Path_Root)/$(realpath --relative-to "$(pwd)" "$BUILD_ARTIFACTSTAGINGDIRECTORY")
      ;;
    "github")
      directory="$(Files_Path_Root)/artifacts"
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
  local filename=$1
  local content=$2

  local directory=$(dirname "$filename")
  if [ ! -d "$(Artifacts_Directory)/$directory" ]; then
    mkdir -p "$(Artifacts_Directory)/$directory"
  fi

  Log_Info "Writing artifact $filename"
  echo "$content" > "$(Artifacts_Directory)/$filename"
}

Artifacts_Read() {
  local filename=$1

  if [ ! -f "$(Artifacts_Directory)/$filename" ]; then
    Log_Error "Artifact $filename does not exist"
    return 1
  fi

  cat "$(Artifacts_Directory)/$filename"
}

Artifacts_Move() {
  local sourceFilename=$1
  local destinationFilename=$2

  if [ ! -f "$sourceFilename" ]; then
    Log_Error "Artifact $sourceFilename does not exist"
    return 1
  fi

  local directory=

  if [[ $destinationFilename == */ ]]; then
    directory="$destinationFilename"
  else
    directory=$(dirname "$destinationFilename")
  fi

  if [ ! -d "$(Artifacts_Directory)/$directory" ]; then
    mkdir -p "$(Artifacts_Directory)/$directory"
  fi

  Log_Info "Moving artifact $sourceFilename to $(Artifacts_Directory)/$destinationFilename"
  mv "$sourceFilename" "$(Artifacts_Directory)/$destinationFilename"
}

Artifacts_Delete() {
  local filename=$1

  if [ ! -f "$(Artifacts_Directory)/$filename" ]; then
    Log_Error "Artifact $filename does not exist"
    return 1
  fi

  Log_Info "Deleting artifact $filename"
  rm "$(Artifacts_Directory)/$filename"
}