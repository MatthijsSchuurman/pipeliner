#!/bin/bash

source $(Files_Path_Pipeliner)/core/ssh.sh
source $(Files_Path_Pipeliner)/core/compression.sh

UnitTest_SSH_Directory() {
  #Given
  local actual=

  #When
  actual=$(SSH_Directory)

  #Then
  Assert_Equal "$actual" "$(Files_Path_Root)/.ssh"
}

UnitTest_SSH__Key_File() {
  #Given
  local actual=

  #When
  actual=$(SSH__Key_File)

  #Then
  Assert_Equal "$actual" "$(SSH_Directory)/pipeliner"

  #Given
  local keyName="pipeliner-test"

  #When
  actual=$(SSH__Key_File "$keyName")

  #Then
  Assert_Equal "$actual" "$(SSH_Directory)/$keyName"
}

UnitTest_SSH__Key_File_Public() {
  #Given
  local actual=

  #When
  actual=$(SSH__Key_File_Public)

  #Then
  Assert_Equal "$actual" "$(SSH_Directory)/pipeliner.pub"

  #Given
  local keyName="pipeliner-test"

  #When
  actual=$(SSH__Key_File_Public "$keyName")

  #Then
  Assert_Equal "$actual" "$(SSH_Directory)/$keyName.pub"
}

UnitTest_SSH__Remote_Authorized_Keys_File() {
  #Given
  local actual=

  #When
  actual=$(SSH__Remote_Authorized_Keys_File)

  #Then
  Assert_Equal "$actual" "~/.ssh/authorized_keys"
}

UnitTest_SSH_Key_Exists() {
  #Given
  local actual=
  local keyName="pipeliner-test"

  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")

  rm -f "$keyFile" "$keyFilePublic"

  #When
  SSH_Key_Exists "$keyName"
  actual=$?

  #Then
  Assert_Equal "$actual" 1

  #Given
  SSH_Generate_Key "$keyName"

  #When
  SSH_Key_Exists "$keyName"
  actual=$?

  #Then
  Assert_Equal "$actual" 0

  #Cleanup
  rm -f "$keyFile" "$keyFilePublic"
}

UnitTest_SSH_Generate_Key() {
  #Given
  local actual=
  local keyName="pipeliner-test"

  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")

  rm -f "$keyFile" "$keyFilePublic"

  #When
  actual=$(SSH_Generate_Key "$keyName")

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "SSH generating key: $keyFile" "ed25519" ENDGROUP
  else
    Assert_Contains "$actual" group "SSH generating key: $keyFile" "ed25519" endgroup
  fi

  Assert_File_Exists "$keyFile"
  Assert_File_Exists "$keyFilePublic"

  #Given

  #When
  actual=$(SSH_Generate_Key "$keyName")

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" INFO "SSH key already exists: $keyFile"
  else
    Assert_Contains "$actual" info "SSH key already exists: $keyFile"
  fi

  Assert_File_Exists "$keyFile"
  Assert_File_Exists "$keyFilePublic"

  #Cleanup
  rm -f "$keyFile" "$keyFilePublic"
}

UnitTest_SSH__Dissect_URL() {
  #Given
  local actual=
  local url="localhost"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  $(Dictionary_Exists "$actual" "user")
  Assert_Equal $? 1
  $(Dictionary_Exists "$actual" "port")
  Assert_Equal $? 1
  $(Dictionary_Exists "$actual" "path")
  Assert_Equal $? 1


  #Given
  url="user@localhost"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  Assert_Equal "$(Dictionary_Get "$actual" "user")" "user"
  $(Dictionary_Exists "$actual" "port")
  Assert_Equal $? 1
  $(Dictionary_Exists "$actual" "path")
  Assert_Equal $? 1


  #Given
  url="localhost:22"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  $(Dictionary_Exists "$actual" "user")
  Assert_Equal $? 1
  Assert_Equal "$(Dictionary_Get "$actual" "port")" "22"
  $(Dictionary_Exists "$actual" "path")
  Assert_Equal $? 1


  #Given
  url="localhost:22/path/to/file"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  $(Dictionary_Exists "$actual" "user")
  Assert_Equal $? 1
  Assert_Equal "$(Dictionary_Get "$actual" "port")" "22"
  Assert_Equal "$(Dictionary_Get "$actual" "path")" "path/to/file"
}

UnitTest_SSH__Dissect_URL_Arguments() {
  #Given
  local actual=
  local url="localhost?key=value&key2=value2"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  $(Dictionary_Exists "$actual" "user")
  Assert_Equal $? 1
  $(Dictionary_Exists "$actual" "port")
  Assert_Equal $? 1
  $(Dictionary_Exists "$actual" "path")
  Assert_Equal $? 1
  Assert_Equal "$(Dictionary_Get "$actual" "key")" "value"
  Assert_Equal "$(Dictionary_Get "$actual" "key2")" "value2"


  #Given
  url="localhost?key=value&key2=value2&key=value3"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "key")" "value"
  Assert_Equal "$(Dictionary_Get "$actual" "key2")" "value2"


  #Given
  url="user@localhost:22/path/to/file?host=localhost2&user=user2&port=23&path=path2"

  #When
  actual=$(SSH__Dissect_URL "$url")

  #Then
  Assert_Equal "$(Dictionary_Get "$actual" "host")" "localhost"
  Assert_Equal "$(Dictionary_Get "$actual" "user")" "user"
  Assert_Equal "$(Dictionary_Get "$actual" "port")" "22"
  Assert_Equal "$(Dictionary_Get "$actual" "path")" "path/to/file"
}

UnitTest_SSH_Deploy_Key() {
  #Given
  local actual=
  local host="localhost"
  local keyName="pipeliner-test"

  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")
  local remoteKeysFile=$(SSH__Remote_Authorized_Keys_File)
  remoteKeysFile=$(eval realpath -m $remoteKeysFile) #get actual home directory

  rm -f "$keyFile" "$keyFilePublic"

  SSH_Generate_Key "$keyName"
  local keyPublic=$(cat "$keyFilePublic")

  if [ -f "$remoteKeysFile" ]; then
    cp "$remoteKeysFile" "$remoteKeysFile.bak"
  fi

  mkdir ~/.ssh/ 2>/dev/null
  echo "$keyPublic" >> ~/.ssh/authorized_keys #need so test can be ran without password

  ssh-keygen -R localhost > /dev/null 2>&1 #ensure no host key is present

  #When
  actual=$(SSH_Deploy_Key "$host?key=$keyName" 2> /dev/null)

  #Then
  Assert_Equal "$actual" ""

  local keyCount=$(grep -F "$keyPublic" $remoteKeysFile | wc -l | xargs)
  Assert_Equal "$keyCount" 2 #one for the test and one for the actual key

  #Cleanup
  rm -f "$keyFile" "$keyFilePublic"

  if [ -f "$remoteKeysFile.bak" ]; then
    mv "$remoteKeysFile.bak" "$remoteKeysFile"
  else #no original file
    rm -f "$remoteKeysFile"
  fi
}

UnitTest_SSH_Run() {
  #Given
  local actual=
  local exitCode=

  local host="localhost"
  local command="echo \$SSH_CLIENT"

  local keyName="pipeliner-localhost-test"
  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")

  if [ ! -f "$keyFile" ]; then
    SSH_Generate_Key "$keyName"

    mkdir ~/.ssh/ 2>/dev/null
    cat "$keyFilePublic" >> ~/.ssh/authorized_keys
  fi

  ssh-keygen -R localhost > /dev/null 2>&1 #ensure no host key is present

  #When
  actual=$(SSH_Run "$host?key=$keyName" "$command" 2> /dev/null)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Not_Empty "$actual"


  #When
  actual=$(SSH_Run "$host?key=$keyName" pwd "ls -la" 2> /dev/null)

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_OS) == "macos" ]; then
    Assert_Contains "$actual" "Users" .. drwx
  else
    Assert_Contains "$actual" "home" .. drwx
  fi
}

UnitTest_SSH_Copy() {
  #Given
  local actual=
  local host="localhost"
  local sourceFile=$(Files_Path_Pipeliner)/README.md
  local destinationFile=~/README.md

  local keyName="pipeliner-localhost-test"
  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")

  if [ ! -f "$keyFile" ]; then
    SSH_Generate_Key "$keyName"

    mkdir ~/.ssh/ 2>/dev/null
    cat "$keyFilePublic" >> ~/.ssh/authorized_keys
  fi

  ssh-keygen -R localhost 2>/dev/null #ensure no host key is present

  #When
  actual=$(SSH_Copy "$host?key=$keyName" "$sourceFile" "$destinationFile" 2> /dev/null)

  #Then
  Assert_Equal "$actual" ""

  destinationFile=$(eval realpath $destinationFile) #get actual home directory
  Assert_File_Exists "$destinationFile"

  #Cleanup
  rm -f "$destinationFile"
}

UnitTest_SSH_Compression_ZIP_Example() {
  #Given
  local actual=
  local exitCode=
  local host="localhost"

  local keyName="pipeliner-localhost-test"
  local keyFile=$(SSH__Key_File "$keyName")
  local keyFilePublic=$(SSH__Key_File_Public "$keyName")

  if [ ! -f "$keyFile" ]; then
    SSH_Generate_Key "$keyName"

    mkdir ~/.ssh/ 2>/dev/null
    cat "$keyFilePublic" >> ~/.ssh/authorized_keys
  fi

  ssh-keygen -R localhost > /dev/null 2>&1 #ensure no host key is present

  touch ~/pipeliner-test.txt
  rm -f ~/pipeliner-test.zip

  #When
  zip() { #Wrap zip command in SSH
    SSH_Run "localhost?key=$keyName" "zip $(IFS=" " ; echo "$*")" 2> /dev/null
  }

  actual=$(Compression_Zip pipeliner-test.zip pipeliner-test.txt)
  exitCode=$?

  echo "$actual"
  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping pipeliner-test.zip" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping pipeliner-test.zip" endgroup
  fi

  Assert_File_Exists ~/pipeliner-test.zip
  Assert_Contains "$actual" adding pipeliner-test.txt

  #Clean
  rm -f ~/pipeliner-test.zip ~/pipeliner-test.txt
}