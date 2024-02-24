#!/bin/bash

IntegrationTest_Examples_JVM_Stage_Build_java() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  JVM_Pipelines_Stage_Build examples/jvm/app-java

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

IntegrationTest_Examples_JVM_Stage_Build_kotlin() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  JVM_Pipelines_Stage_Build examples/jvm/app-kotlin

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