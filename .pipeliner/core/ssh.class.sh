#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/utils/files.class.sh

SSH_Directory() {
  echo "$(Files_Path_Root)/.ssh"
}

SSH__Key_File() {
  local keyName=${1:-"pipeliner"}
  local keyFile=$(SSH_Directory)/$keyName

  echo "$keyFile"
}

SSH__Key_File_Public() {
  local keyFile=$(SSH__Key_File "$1")

  echo "$keyFile.pub"
}

SSH__Remote_Authorized_Keys_File() {
  echo "~/.ssh/authorized_keys"
}

SSH_Key_Exists() {
  local keyName=$1
  local keyFile=$(SSH__Key_File "$keyName")

  if [ -f "$keyFile" ]; then
    return 0
  fi

  return 1
}

SSH_Generate_Key() {
  local keyName=$1
  local keyFile=$(SSH__Key_File "$keyName")

  if SSH_Key_Exists "$keyName"; then
    Log_Info "SSH key already exists: $keyFile"
    return
  fi

  if [ ! -d "$(SSH_Directory)" ]; then
    mkdir -p "$(SSH_Directory)"
  fi

  Log_Group "SSH generating key: $keyFile"
  ssh-keygen -t ed25519 -f "$keyFile" -N ""
  Log_Group_End
}

SSH__Dissect_URL() {
  local url=$1
  local dictionary=

  local user=
  if [[ $url == *"@"* ]]; then
    user="$(echo $url | cut -d '@' -f 1)"
    url=$(echo $url | cut -d '@' -f 2-)
  fi

  local arguments=
  if [[ $url == *"?"* ]]; then
    arguments="$(echo $url | cut -d '?' -f 2-)"
    url=$(echo $url | cut -d '?' -f 1)
  fi

  local path=
  if [[ $url == *"/"* ]]; then
    path="$(echo $url | cut -d '/' -f 2-)"
    url=$(echo $url | cut -d '/' -f 1)
  fi

  local host=
  local port=
  if [[ $url == *":"* ]]; then
    host="$(echo $url | cut -d ':' -f 1)"
    port="$(echo $url | cut -d ':' -f 2)"
  else
    host=$url
  fi

  dictionary=$(Dictionary_Set "$dictionary" "host" "$host")
  if [ "$user" ]; then
    dictionary=$(Dictionary_Set "$dictionary" "user" "$user")
  fi
  if [ "$port" ]; then
    dictionary=$(Dictionary_Set "$dictionary" "port" "$port")
  fi
  if [ "$path" ]; then
    dictionary=$(Dictionary_Set "$dictionary" "path" "$path")
  fi

  if  [ "$arguments" ]; then
    local argumentsArray=($(echo $arguments | tr "&" "\n"))
    for argument in "${argumentsArray[@]}"; do
      local key=$(echo $argument | cut -d '=' -f 1)
      if ! $(Dictionary_Exists "$dictionary" "$key"); then
        local value=$(echo $argument | cut -d '=' -f 2)
        dictionary=$(Dictionary_Set "$dictionary" "$key" "$value")
      fi
    done
  fi

  echo "$dictionary"
}

SSH_Run() {
  local url=$(SSH__Dissect_URL "$1")

  local commands=
  if [ ${#@} -gt 1 ]; then
    shift 1
    commands=$@
  fi

  local keyName=$(Dictionary_Get "$url" "key")
  local keyFile=$(SSH__Key_File "$keyName")
  local exitCode=

  local ssh="ssh -i $keyFile"
  ssh+=" -o StrictHostKeyChecking=no"

  if Dictionary_Exists "$url" "port"; then
    ssh+=" -p $(Dictionary_Get "$url" "port")"
  fi

  if Dictionary_Exists "$url" "user"; then
    ssh+=" $(Dictionary_Get "$url" "user")@"
  fi

  ssh+=" $(Dictionary_Get "$url" "host")"

  ssh+=" $commands"

  $ssh
  exitCode=$?

  if [ $exitCode == 255 ]; then
    Log_Error "SSH connection failed"
  fi

  return $exitCode
}

SSH_Deploy_Key() {
  local urlString=$1
  local url=$(SSH__Dissect_URL "$urlString")

  local keyFilePublic=$(SSH__Key_File_Public "$keyName")
  local keyPublic=$(cat "$keyFilePublic")
  local remoteKeysFile=$(SSH__Remote_Authorized_Keys_File)

  local command="echo "$keyPublic" >> $remoteKeysFile"

  SSH_Run "$urlString" "$command"
}

SSH_Copy() {
  local url=$(SSH__Dissect_URL "$1")
  local sourceFile=$2
  local destinationFile=$3

  local keyName=$(Dictionary_Get "$url" "key")
  local keyFile=$(SSH__Key_File "$keyName")
  local exitCode=

  local scp="scp -i $keyFile"
  scp+=" -o StrictHostKeyChecking=no"
  scp+=" $sourceFile"

  if Dictionary_Exists "$url" "port"; then
    scp+=" -P $(Dictionary_Get "$url" "port")"
  fi

  if Dictionary_Exists "$url" "user"; then
    scp+=" $(Dictionary_Get "$url" "user")@"
  fi

  scp+=" $(Dictionary_Get "$url" "host")"
  scp+=":$destinationFile"

  $scp
  exitCode=$?

  if [ $exitCode == 255 ]; then
    Log_Error "SSH connection failed"
  fi

  return $exitCode
}