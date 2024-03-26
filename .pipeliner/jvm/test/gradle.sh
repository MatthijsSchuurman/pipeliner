#!/bin/bash

source $(Files_Path_Pipeliner)/jvm/gradle.class.sh

UnitTest_Gradle_Clean() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(JVM_Gradle_Clean examples/jvm/app-java)
  exitCode=$?

  echo "actual: $actual"
  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_Not_Directory_Exists examples/jvm/app-java/build/


  #When
  actual=$(JVM_Gradle_Clean examples/jvm/app-kotlin)
  exitCode=$?
  echo "actual: $actual"

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_Not_Directory_Exists examples/jvm/app-kotlin/build/
}

UnitTest_Gradle_Build() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(JVM_Gradle_Build examples/jvm/app-java)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_Directory_Exists examples/jvm/app-java/build/libs/

  #Clean
  rm -rf examples/jvm/app-java/build/


  #When
  actual=$(JVM_Gradle_Build examples/jvm/app-kotlin)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_Directory_Exists examples/jvm/app-kotlin/build/libs/

  #Clean
  rm -rf examples/jvm/app-kotlin/build/
}

UnitTest_Gradle_Test() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(JVM_Gradle_Test examples/jvm/app-java)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_File_Exists examples/jvm/app-java/build/reports/tests/test/index.html

  #Clean
  rm -rf examples/jvm/app-java/build/


  #When
  actual=$(JVM_Gradle_Test examples/jvm/app-kotlin)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL"
  Assert_File_Exists examples/jvm/app-kotlin/build/reports/tests/test/index.html

  #Clean
  rm -rf examples/jvm/app-kotlin/build/
}

UnitTest_Gradle_Run() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(JVM_Gradle_Run examples/jvm/app-java)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL" "Hello, World!"

  #Clean
  rm -rf examples/jvm/app-java/build/


  #When
  actual=$(JVM_Gradle_Run examples/jvm/app-kotlin)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "BUILD SUCCESSFUL" "Hello, World!"

  #Clean
  rm -rf examples/jvm/app-kotlin/build/
}