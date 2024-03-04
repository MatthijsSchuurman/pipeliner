#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/init.sh


#Main logic
argumentsDefinition="
agent: agent #Azure DevOps agent commands: start, command, stop, clean

--help: help #Show usage information
--version: version #Show version information
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
  Packages_Prerequisites vagrant virtualbox

  if Dictionary_Exists "$arguments" agent,0 ; then
    if [ "$(Dictionary_Get "$arguments" agent,0)" == "stop" ]; then
      Vagrant_Halt azdo
    elif [ "$(Dictionary_Get "$arguments" agent,0)" == "clean" ]; then
      Vagrant_Destroy azdo
    else
      if ! Vagrant_Running azdo ; then
        Vagrant_Up azdo
      fi

      if [ "$(Dictionary_Get "$arguments" agent,0)" == "command" ]; then
        Vagrant_SSH azdo "$(Dictionary_Get "$arguments" 0)"
      fi
    fi
  else
    Log_Error "Unknown command"
    echo
    CLI_Arguments_Usage ${BASH_SOURCE[0]} "$argumentsDefinition"
    echo
    exit 1
  fi
fi

echo