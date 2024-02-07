#!/bin/bash

source $(Files_Path_Pipeliner)/core/environment.class.sh
source $(Files_Path_Pipeliner)/core/utils/misc.sh
source $(Files_Path_Pipeliner)/core/log.class.sh

Version_Pipeliner() {
  #get version from first line of README.md
  head -n 1 $(Files_Path_Pipeliner)/README.md | sed -E "s/.*v([0-9]+\.[0-9]+).*/\1/"
}

Version_Pipeliner_Full() {
  local version=$(Version_Pipeliner)
  local buildId=$(Version_BuildId)

  echo "$version.$buildId"
}

Version_Pipeliner_Code() {
  version=$(explode . $(Version_Pipeliner_Full))

  printf "%01d%02d%05d" ${version[0]} ${version[1]} ${version[2]}
}

Version_BuildId() {
  local version=

  case $(Environment_Platform) in
    "azure")
      version=$BUILD_BUILDID
      ;;
    "github")
      version=$GITHUB_RUN_NUMBER
      ;;
    "local")
      if [ ! "$PIPELINER_BUILDID" ]; then
        Log_Error "Local build id is not set, please run Version_BuildId_Next first" >&2
        exit 1
      fi

      version=$PIPELINER_BUILDID
      ;;
    *)
      Log_Error "Version BuildId for $(Environment_Platform) platform is not supported" >&2
      exit 1
      ;;
  esac

  echo $version
}

Version_BuildId_Next() {
  if [ $(Environment_Platform) != "local" ]; then
    Log_Error "Version BuildId Next is only supported for local platform" >&2
    exit 1
  fi

  local buildId=1

  if [ -f "$(Files_Path_Data)/.buildId" ]; then
    buildId=$(cat $(Files_Path_Data)/.buildId)
    buildId=$((buildId+1))
  fi

  echo $buildId > $(Files_Path_Data)/.buildId
  PIPELINER_BUILDID=$buildId
}
