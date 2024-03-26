#!/bin/bash

source $(Files_Path_Pipeliner)/jvm/jvm.sh

UnitTest_JVM_Dockerfile() {
  #Given
  local tools=(ls java gradle)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner jvm "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done


  #When
  actual=$(Docker_Runner jvm "" "" "java --version")

  #Then
  Assert_Match "$actual" "openjdk 21\.[0-9]+\.[0-9]+"


  #When
  actual=$(Docker_Runner jvm "" "" "gradle --version")

  #Then
  Assert_Match "$actual" "Gradle 8\.6"
}

UnitTest_JVM_Run() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/jvm

  #When
  actual=$(JVM_Run $workdir "java --version")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "openjdk [0-9]+\.[0-9]+\.[0-9]+"

  #When
  actual=$(JVM_Run $workdir "gradle --version" "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Gradle [0-9]+\.[0-9]+" examples drwx
}
