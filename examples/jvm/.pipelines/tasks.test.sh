#!/bin/bash

IntegrationTest_Examples_JVM_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(JVM_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/jvm/app-java examples/jvm/app-kotlin
}

IntegrationTest_Examples_JVM_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

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


IntegrationTest_Examples_JVM_Pipelines_Build_java() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  JVM_Pipelines_Build examples/jvm/app-java

  #Then
  actual=$(Docker_List examples/jvm/app-java:latest)
  Assert_Contains "$actual" "examples/jvm/app-java" "latest"

  actual=$(Docker_Run examples/jvm/app-java:latest "" "" "java -version")
  Assert_Contains "$actual" "openjdk version" 21

  Docker_Run examples/jvm/app-java:latest "" "" "test -f /home/java/app/bin/HelloWorld"
  Assert_Equal $? 0
  Docker_Run examples/jvm/app-java:latest "" "" "test -d /home/java/app/lib/"
  Assert_Equal $? 0
}

IntegrationTest_Examples_JVM_Pipelines_Build_kotlin() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  JVM_Pipelines_Build examples/jvm/app-kotlin

  #Then
  actual=$(Docker_List examples/jvm/app-kotlin:latest)
  Assert_Contains "$actual" "examples/jvm/app-kotlin" "latest"

  actual=$(Docker_Run examples/jvm/app-kotlin:latest "" "" "java -version")
  Assert_Contains "$actual" "openjdk version" 21

  Docker_Run examples/jvm/app-kotlin:latest "" "" "test -f /home/java/app/bin/HelloWorld"
  Assert_Equal $? 0
  Docker_Run examples/jvm/app-kotlin:latest "" "" "test -d /home/java/app/lib/"
  Assert_Equal $? 0
}


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