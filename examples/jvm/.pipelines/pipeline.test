#!/bin/bash

IntegrationTest_Examples_JVM_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  local actual=$(JVM_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/jvm/app-java examples/jvm/app-kotlin
}

IntegrationTest_Examples_JVM_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  VCS_Affected_Directories() { #mock
    echo "examples/jvm/app-java"
  }

  #When
  local actual=$(JVM_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/jvm/app-java
  Assert_Not_Contains "$actual" examples/jvm/app-kotlin
}