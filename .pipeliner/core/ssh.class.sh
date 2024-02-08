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

  if [[ $url == *"@"* ]]; then
    dictionary=$(Dictionary_Set "" "user" "$(echo $url | cut -d'@' -f1)")
    url=$(echo $url | cut -d'@' -f2)
  fi

  if [[ $url == *":"* ]]; then
    dictionary=$(Dictionary_Set "$dictionary" "host" "$(echo $url | cut -d':' -f1)")
    dictionary=$(Dictionary_Set "$dictionary" "port" "$(echo $url | cut -d':' -f2)")
  else
    dictionary=$(Dictionary_Set "$dictionary" "host" "$url")
  fi

  echo "$dictionary"
}

SSH_Run() {
  local url=$(SSH__Dissect_URL "$1")
  local command=$2
  local keyName=$3

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

  ssh+=" $command"

  $ssh
  exitCode=$?

  if [ $exitCode == 255 ]; then
    Log_Error "SSH connection failed"
  fi

  return $exitCode
}

SSH_Deploy_Key() {
  local url=$1
  local keyName=$2

  local keyFilePublic=$(SSH__Key_File_Public "$keyName")
  local keyPublic=$(cat "$keyFilePublic")
  local remoteKeysFile=$(SSH__Remote_Authorized_Keys_File)

  local command="echo "$keyPublic" >> $remoteKeysFile"

  SSH_Run "$url" "$command" "$keyName"
}

SSH_Copy() {
  local url=$(SSH__Dissect_URL "$1")
  local sourceFile=$2
  local destinationFile=$3
  local keyName=$4

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