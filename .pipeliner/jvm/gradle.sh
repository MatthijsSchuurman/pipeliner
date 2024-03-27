#!/bin/bash

source $(Files_Path_Pipeliner)/jvm/jvm.sh

JVM_Gradle_Clean() {
  local workdir=$1

  Log_Info "Gradle Clean"
  JVM_Run "$workdir" "gradle clean"
}

JVM_Gradle_Build() {
  local workdir=$1

  Log_Info "Gradle Build"
  JVM_Run "$workdir" "gradle build"
}

JVM_Gradle_Test() {
  local workdir=$1

  Log_Info "Gradle Test"
  JVM_Run "$workdir" "gradle test"
}

JVM_Gradle_Run() {
  local workdir=$1

  Log_Info "Gradle Run"
  JVM_Run "$workdir" "gradle run"
}