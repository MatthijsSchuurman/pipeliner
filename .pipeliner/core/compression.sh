#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh
source $(Files_Path_Pipeliner)/core/log.class.sh

Compression_Zip() {
  local filename=$1
  shift #remove filename from arguments
  local files=$@

  Log_Group "Zipping $filename"
  zip -r $filename $files
  local exitCode=$?

  if [ $exitCode -ne 0 ]; then
    Log_Error "Zipping failed ($exitCode)"
  fi
  Log_Group_End

  return $exitCode
}