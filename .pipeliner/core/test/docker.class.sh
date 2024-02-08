#!/bin/bash

source $(Files_Path_Pipeliner)/core/docker.class.sh

UnitTest_Docker_Install() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  actual=$(Docker_Install)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Install" ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Install" endgroup
  fi
  Assert_Contains "$actual" "Docker version"

  which docker > /dev/null 2>&1
  Assert_Equal $? 0
}
UnitTest_Docker_Install_Fail() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  which docker > /dev/null 2>&1 #skip if docker is already installed
  if [ $? == 0 ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Environment_Distro() { #mock
    echo "unknown"
  }

  #When
  actual=$(Docker_Install)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" "Docker is not supported on unknown unknown"
}

UnitTest_Docker_Build() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=
  Docker_Install

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
  Docker_Install

  #When
  actual=$(Docker_Build $(Files_Path_Pipeliner)/core/test/Dockerfile core-test:test "key1=value1 key2=value2")
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

UnitTest_Docker_Run_node() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Docker_Install
  Docker_Build $(Files_Path_Pipeliner)/node/Dockerfile node:test

  #When
  actual=$(Docker_Run node:test pwd)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Run" node:test pwd ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Run" node:test pwd endgroup
  fi

  #When
  actual=$(Docker_Run node:test pwd .pipeliner/)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Run" node:test pwd ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Run" node:test pwd endgroup
  fi
}
UnitTest_Docker_Run_dotnet() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Docker_Install
  Docker_Build $(Files_Path_Pipeliner)/dotnet/Dockerfile dotnet:test

  #When
  actual=$(Docker_Run dotnet:test pwd)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Docker Run" dotnet:test pwd ENDGROUP
  else
    Assert_Contains "$actual" group "Docker Run" dotnet:test pwd endgroup
  fi
}
UnitTest_Docker_Run_Owner() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  Docker_Install
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  Docker_Run core:test "touch asd"

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

  Docker_Install
  Docker_Build $(Files_Path_Pipeliner)/core/Dockerfile core:test

  #When
  actual=$(Docker_Run core:test "env" "" "asd=123")

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
  Docker_Runner core "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Contains "$actual" "Docker Run core:runner ls"
  Assert_Contains "$actual" "Build"
  Assert_Contains "$actual" "examples"
  Assert_Contains "$PIPELINER_IMAGES_BUILT" "core"
  Assert_Equal $buildCounter 1

  #Given build was already done

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner core "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Contains "$actual" "Docker run core:runner ls"
  Assert_Not_Contains "$actual" "Build"
  Assert_Contains "$actual" "examples"
  Assert_Contains "$PIPELINER_IMAGES_BUILT" "core"
  Assert_Equal $buildCounter 1
}
UnitTest_Docker_Runner_node() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner node "ls -la" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Contains "$actual" "Docker run node:runner ls"
  Assert_Contains "$actual" "examples"
  Assert_Contains "$PIPELINER_IMAGES_BUILT" "node"
}
UnitTest_Docker_Runner_Fail() {
  if [ "$(Environment_Platform)" == "docker" ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  Docker_Runner UNKNOWN "ls -la" > $logFile 2>&1
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

  Docker_Install
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

  Docker_Install
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
    Docker_Runner core "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done
}