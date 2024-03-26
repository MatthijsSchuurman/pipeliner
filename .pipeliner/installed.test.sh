#!/bin/bash

UnitTest_Installed_Pipeliner() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/init
  Assert_File_Exists $(Files_Path_Pipeliner)/install

  Assert_File_Exists $(Files_Path_Pipeliner)/README.md
  Assert_File_Exists $(Files_Path_Pipeliner)/LICENSE.md
}

UnitTest_Installed_Pipeliner_Docker() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)/core/

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/docker
  Assert_File_Exists $(Files_Path_Pipeliner)/core/docker.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/docker.test.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/Dockerfile
}

UnitTest_Installed_Pipeliner_Test() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)/core/

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/test
  Assert_File_Exists $(Files_Path_Pipeliner)/core/test.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/test.test.sh
}

UnitTest_Installed_AzureDevOps() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/.azuredevops/

  #Then
  Assert_File_Exists $(Files_Path_Root)/.azuredevops/ci.yml
}

UnitTest_Installed_GitHub() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/.github/

  #Then
  Assert_File_Exists $(Files_Path_Root)/.github/workflows/ci.yml
}

UnitTest_Installed_Vagrant() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)

  #Then
  Assert_File_Exists $(Files_Path_Root)/Vagrantfile
}

UnitTest_Installed_VSCode() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/.vscode/

  #Then
  Assert_File_Exists $(Files_Path_Root)/.vscode/extensions.json
  Assert_File_Exists $(Files_Path_Root)/.vscode/tasks.json
}

UnitTest_Installed_Examples_DotNet() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/examples/dotnet/

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/.pipelines/ci.local.sh
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/work.sln
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/src/main.cs
}

UnitTest_Installed_Examples_JVM() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/examples/jvm/

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/.pipelines/ci.local.sh
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-java/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-java/build.gradle
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-java/src/Main.java
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-kotlin/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-kotlin/build.gradle.kts
  Assert_File_Exists $(Files_Path_Root)/examples/jvm/app-kotlin/src/Main.kt
}

UnitTest_Installed_Examples_Node() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/examples/node/

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/node/.pipelines/ci.local.sh
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/node/app1/package.json
}

UnitTest_Installed_Examples_PHP() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/examples/php/

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/php/.pipelines/ci.local.sh
  Assert_File_Exists $(Files_Path_Root)/examples/php/app1/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/php/app1/composer.json
  Assert_File_Exists $(Files_Path_Root)/examples/php/app1/src/index.php
}