#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.sh
source $(Files_Path_Pipeliner)/core/compression.sh
source $(Files_Path_Pipeliner)/core/packages.sh

UnitTest_Docker_Build() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=
  Packages_Prerequisites docker

  #When
  actual=$(Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Build" core/Dockerfile core:test ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Build" core/Dockerfile core:test endgroup
  fi
}

UnitTest_Docker_Build_Arguments() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=
  Packages_Prerequisites docker

  #When
  actual=$(Docker_Build $(Files_Path_Pipeliner)/core/test/Dockerfile core-test:test "key1=value1 key2=value2")
  actual2=$(Docker_Run core-test:test)
  exitCode=$?

  echo "$actual2"

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Build" core/test/Dockerfile core-test:test ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Build" core/test/Dockerfile core-test:test endgroup
  fi

  Assert_Contains "$actual2" key1=value1
  Assert_Contains "$actual2" key2=value2

  #When
  actual=$(Docker_Build $(Files_Path_Pipeliner)/core/test/Dockerfile core-test:test "key1=value1")
  actual2=$(Docker_Run core-test:test)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Build" core/test/Dockerfile core-test:test ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Build" core/test/Dockerfile core-test:test endgroup
  fi

  Assert_Contains "$actual2" key1=value1
  Assert_Contains "$actual2" key2=default2
}


UnitTest_Docker_Run_core() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Packages_Prerequisites docker
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  actual=$(Docker_Run core:test "" "" pwd)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Run" core:test pwd ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Run" core:test pwd endgroup
  fi

  Assert_Contains "$actual" "work"

  #Given build was already done

  #When
  actual=$(Docker_Run core:test .pipeliner/ "" pwd "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Run" core:test pwd ls ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Run" core:test pwd ls endgroup
  fi

  Assert_Contains "$actual" "work/.pipeliner" "core" drwx
}

UnitTest_Docker_Run_Owner() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Packages_Prerequisites docker
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  Docker_Run core:test "" "" "touch asd"

  #Then
  Assert_Path_Owner $(Files_Path_Root)/asd $(id -u)
  Assert_Path_Group $(Files_Path_Root)/asd $(id -g)
  rm $(Files_Path_Root)/asd
}

UnitTest_Docker_Run_Env() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Packages_Prerequisites docker
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  actual=$(Docker_Run core:test "" "asd=123" "env")

  #Then
  Assert_Contains "$actual" "asd=123"
  Assert_Not_Contains "$actual" "asdasd=123456"
}


UnitTest_Docker_Runner() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=
  local buildCounter=0

  #rename Docker_Build to Docker_Build_Original
  eval "$(declare -f Docker_Build | sed -E "s/Docker_Build/Docker_Build_Original/")"
  Docker_Build() {
    buildCounter=$((buildCounter+1))

    Docker_Build_Original $@
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner core "" "" "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Contains "$actual" "Docker Run core:runner ls"
  Assert_Contains "$actual" "Build" "examples"
  Assert_Contains "$PIPELINER_IMAGES_BUILT" "core"
  Assert_Equal $buildCounter 1

  #Given build was already done

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner core .pipeliner "" pwd "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Contains "$actual" "Docker run core:runner" pwd "ls -la"
  Assert_Not_Contains "$actual" "Build"
  Assert_Contains "$actual" "work/.pipeliner" "core" drwx
  Assert_Contains "$PIPELINER_IMAGES_BUILT" "core"
  Assert_Equal $buildCounter 1
}

UnitTest_Docker_Runner_Fail() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner UNKNOWN "" "" "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" "Docker image UNKNOWN not found"
}


UnitTest_Docker_List() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Packages_Prerequisites docker
  Docker_Build $(Files_Path_Pipeliner)/node/Dockerfile node:test

  #When
  actual=$(Docker_List node:test)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "node test"
}

UnitTest_Docker_List_All() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  actual=$(Docker_List)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "node test" "node"
}


UnitTest_Docker_Save() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Packages_Prerequisites docker
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  actual=$(Docker_Save core:test $(Files_Path_Root)/core-test.tar.gz 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Save" core:test core-test.tar.gz ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Save" core:test core-test.tar.gz endgroup
  fi

  Assert_File_Exists $(Files_Path_Root)/core-test.tar.gz
  Assert_Contains "$(file $(Files_Path_Root)/core-test.tar.gz)" "gzip compressed data"

  #When
  actual=$(Docker_Save core:test $(Files_Path_Root)/core-test.tar.gz 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Save" core:test core-test.tar.gz ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Save" core:test core-test.tar.gz endgroup
  fi
  Assert_Contains "$actual" "Overwriting docker image"

  Assert_File_Exists $(Files_Path_Root)/core-test.tar.gz
  Assert_Contains "$(file $(Files_Path_Root)/core-test.tar.gz)" "gzip compressed data"

  #Clean
  rm $(Files_Path_Root)/core-test.tar.gz

  #When
  actual=$(Docker_Save core:test $(Files_Path_Root)/core-test.tar.xz 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Save" core:test core-test.tar.xz ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Save" core:test core-test.tar.xz endgroup
  fi

  Assert_File_Exists $(Files_Path_Root)/core-test.tar.xz
  Assert_Contains "$(file $(Files_Path_Root)/core-test.tar.xz)" "XZ compressed data"

  #Clean
  rm $(Files_Path_Root)/core-test.tar.xz

  #When
  actual=$(Docker_Save core:test $(Files_Path_Root)/core-test.tar.bz2 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Save" core:test core-test.tar.bz2 ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Save" core:test core-test.tar.bz2 endgroup
  fi

  Assert_File_Exists $(Files_Path_Root)/core-test.tar.bz2
  Assert_Contains "$(file $(Files_Path_Root)/core-test.tar.bz2)" "bzip2 compressed data"

  #Clean
  rm $(Files_Path_Root)/core-test.tar.bz2
}

UnitTest_Docker_Save_Fail() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  actual=$(Docker_Save UNKNOWN:test $(Files_Path_Root)/core-test.tar.gz 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Save" UNKNOWN:test core-test.tar.gz ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Save" UNKNOWN:test core-test.tar.gz endgroup
  fi
  Assert_Contains "$actual" "Failed to save docker image"
  Assert_Not_File_Exists $(Files_Path_Root)/core-test.tar.gz
}


UnitTest_Core_Dockerfile() {
  #Given
  local tools=(ls wget tar xz gzip zip unzip jq git hg)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner core "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done
}


UnitTest_Docker_Compression_ZIP_Example() {
  #Given
  local actual=
  local exitCode=

  rm -f $(Files_Path_Root)/core-test.zip

  #When
  zip() { #Wrap zip command in Docker
    Docker_Runner core "$(Files_Path_Work)" "" "zip $(IFS=" " ; echo "$*")"
  }

  actual=$(Compression_Zip $(Files_Path_Root)/core-test.zip $(Files_Path_Pipeliner)/core/)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping $(Files_Path_Root)/core-test.zip" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping $(Files_Path_Root)/core-test.zip" endgroup
  fi

  Assert_File_Exists $(Files_Path_Root)/core-test.zip
  Assert_Contains "$(file $(Files_Path_Root)/core-test.zip)" "Zip archive data"
  Assert_Contains "$actual" adding core/compression.sh
  Assert_Contains "$actual" adding core/log.sh

  #Clean
  rm -f $(Files_Path_Root)/core-test.zip
}