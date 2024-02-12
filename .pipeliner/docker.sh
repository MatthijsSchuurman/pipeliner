#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/init.sh


#Main logic
argumentsDefinition="
--image: image #Image to run

--help: help #Show usage information
--version: version #Show version information

-i: image #--image
"

arguments=$(CLI_Arguments "$argumentsDefinition" "$@")

if Dictionary_Exists "$arguments" FAILURES ; then
  echo
  CLI_Arguments_Usage ${BASH_SOURCE[0]} "$argumentsDefinition"
  echo
  exit 1
elif Dictionary_Exists "$arguments" help,0 ; then
  CLI_Arguments_Usage ${BASH_SOURCE[0]} "$argumentsDefinition"
elif Dictionary_Exists "$arguments" version,0 ; then
  echo "Pipeliner $(Version_Pipeliner)"
else
  image=core
  if Dictionary_Exists "$arguments" image,0 ; then
    image=$(Dictionary_Get "$arguments" image,0)
  fi

  env=
  if [ $image == node ]; then
    env="npm_config_cache=/work/.npm/cache/"
  fi

  if ! Dictionary_Exists "$arguments" 0 ; then #no commands
    Docker_Runner "$image" "/bin/sh" "$(Files_Path_Work)"
  else
    commandCounter=0
    while true; do
      if ! Dictionary_Exists "$arguments" $commandCounter ; then
        break
      fi

      Docker_Runner "$image" "$(Dictionary_Get "$arguments" $commandCounter)" "$(Files_Path_Work)"
      exitCode=$?

      if [ $exitCode != 0 ]; then
        exit $exitCode
      fi

      commandCounter=$((commandCounter+1))
    done
  fi
fi

echo