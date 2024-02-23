#!/bin/bash

IntegrationTest_Examples_JVM_Stage_Build_java() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  JVM_Pipelines_Stage_Build examples/jvm/app-java

  #Then
  actual=$(Docker_List examples/jvm/app-java:latest)
  Assert_Contains "$actual" "examples/jvm/app-java" "latest"
}

IntegrationTest_Examples_JVM_Stage_Build_kotlin() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  JVM_Pipelines_Stage_Build examples/jvm/app-kotlin

  #Then
  actual=$(Docker_List examples/jvm/app-kotlin:latest)
  Assert_Contains "$actual" "examples/jvm/app-kotlin" "latest"
}