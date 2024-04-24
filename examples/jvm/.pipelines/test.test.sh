#!/bin/bash

IntegrationTest_Examples_JVM_Pipelines_Test_java() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  JVM_Pipelines_Test examples/jvm/app-java

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-java/build/reports/tests/test/index.html

  #Clean
  rm -rf $(Files_Path_Root)/examples/jvm/app-java/build
}

IntegrationTest_Examples_JVM_Pipelines_Test_kotlin() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  JVM_Pipelines_Test examples/jvm/app-kotlin

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-kotlin/build/reports/tests/test/index.html

  #Clean
  rm -rf $(Files_Path_Root)/examples/jvm/app-kotlin/build
}