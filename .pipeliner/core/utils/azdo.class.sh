#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh

AZDO_Agent_Latest() {
  local json=$(wget --quiet --output-document - https://api.github.com/repos/microsoft/azure-pipelines-agent/releases/latest )
  local exitCode=$?

  if [ $exitCode != 0 ]; then
    Log_Error "Failed to get latest AZDO Agent version"
    return $exitCode
  fi

  local version=$(echo "$json"| grep tag_name | cut -d '"' -f 4)
  echo "${version:1}"
}

AZDO_Agent_Download() {
  local version=$1

  if [ ! "$version" ]; then
    local version=$(AZDO_Agent_Latest)
  fi

  local filename="azdo-agent-v$version.tar.gz"
  local url="https://vstsagentpackage.azureedge.net/agent/$version/vsts-agent-linux-x64-$version.tar.gz"

  Log_Group "Downloading AZDO Agent $version"
  wget --quiet --output-document "$filename" "$url"
  local exitCode=$?

  if [ $exitCode != 0 ]; then
    Log_Error "Failed to download AZDO Agent $version"
    Variables_Unset "azdoAgentFilename"
  else
    Variables_Set "azdoAgentFilename" "$filename"
  fi

  Log_Group_End
  return $exitCode
}

AZDO_Agent_Install() {
  local filename=$1
  local directory=${2:-~/agent}

  Log_Group "Installing AZDO Agent $filename"

  if [ ! -f "$filename" ]; then
    Log_Error "File not found: $filename"
    Log_Group_End
    return 1
  fi

  if [ -d "$directory" ]; then
    Log_Error "Directory already exists: $directory"
    Log_Group_End
    return 1
  fi

  tar -tzf "$filename" 2>&1 | grep -q "svc.sh"
  if [ $? != 0 ]; then
    Log_Error "Invalid AZDO Agent file: $filename"
    Log_Group_End
    return 1
  fi

  mkdir -p "$directory"
  tar -xzf "$filename" -C "$directory" 2>&1
  local exitCode=$?

  if [ $exitCode != 0 ]; then
    Log_Error "Failed to install AZDO Agent"
    Log_Group_End
    return $exitCode
  fi

  Log_Group_End
  return $exitCode
}