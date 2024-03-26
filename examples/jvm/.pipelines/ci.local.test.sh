#!/bin/bash

E2ETest_Examples_JVM_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Root)/examples/jvm/.pipelines/ci.local.sh examples/jvm/app-java)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
  Assert_Contains "$actual" "WARNING Running CI pipeline for examples/jvm/app-java"
  Assert_Contains "$actual" "GROUP Docker Build ./.pipeliner/jvm/Dockerfile"
  Assert_Contains "$actual" "INFO Gradle Test"
  Assert_Contains "$actual" "GROUP Docker Run jvm:runner gradle test"
  Assert_Contains "$actual" "INFO Gradle Build"
  Assert_Contains "$actual" "GROUP Docker Run jvm:runner gradle build"
  Assert_Contains "$actual" "GROUP Docker Build Dockerfile examples/jvm/app-java"
  Assert_Contains "$actual" "INFO CI pipline for examples/jvm/app-java done"
}