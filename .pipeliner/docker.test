#!/bin/bash

E2ETest_Docker() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh "echo 'Hello, World!'")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "core:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "core:runner" endgroup
  fi

  Assert_Contains "$actual" "Hello, World!"

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh pwd "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" work examples


  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh -i core "UNKNOWN_COMMAND")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 127
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "core:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "core:runner" endgroup
  fi
}

E2ETest_Docker_node() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh --image node "node --help")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "node:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "node:runner" endgroup
  fi

  Assert_Contains "$actual" "Usage: node"

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh -i node "UNKNOWN_COMMAND")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 127
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "node:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "node:runner" endgroup
  fi
}

E2ETest_Docker_dotnet() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh --image dotnet "dotnet --help")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "dotnet:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "dotnet:runner" endgroup
  fi

  Assert_Contains "$actual" "Usage: dotnet"

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh -i dotnet "UNKNOWN_COMMAND")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 127
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
    Assert_Contains "$actual" GROUP "Docker Build" "Docker Run" "dotnet:runner" ENDGROUP
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" group "Docker Build" "Docker Run" "dotnet:runner" endgroup
  fi
}

E2ETest_Docker_unknown() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh -i unknown "UNKNOWN_COMMAND" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
  fi

  Assert_Contains "$actual" "Docker image unknown not found"
}

E2ETest_Docker_Arguments() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh --help)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Usage:" "docker.sh" "options"
  Assert_Contains "$actual" "--image" "Image to run"
  Assert_Contains "$actual" "--help" "Show usage information"
  Assert_Contains "$actual" "--version" "Show version information"
  Assert_Contains "$actual" "-i" "--image"

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh --version)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Pipeliner $(Version_Pipeliner)"
}

E2ETest_Docker_Arguments_Fail() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/docker.sh --unknown 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" "Unknown argument: --unknown"
}