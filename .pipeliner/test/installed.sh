#!/bin/bash

UnitTest_Installed_Pipeliner() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/init.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/install.sh

  Assert_File_Exists $(Files_Path_Pipeliner)/README.md
  Assert_File_Exists $(Files_Path_Pipeliner)/LICENSE.md
}

UnitTest_Installed_Pipeliner_Docker() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)/core/

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/docker.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/docker.class.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/test/docker.class.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/Dockerfile
}

UnitTest_Installed_Pipeliner_Test() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Pipeliner)/core/utils/

  #Then
  Assert_File_Exists $(Files_Path_Pipeliner)/test.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/utils/test.class.sh
  Assert_File_Exists $(Files_Path_Pipeliner)/core/utils/test/test.class.sh
}

UnitTest_Installed_VSCode() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/.vscode/

  #Then
  Assert_File_Exists $(Files_Path_Root)/.vscode/extensions.json
  Assert_File_Exists $(Files_Path_Root)/.vscode/tasks.json
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

UnitTest_Installed_Examples_DotNet() {
  #Given

  #When
  Assert_Directory_Exists $(Files_Path_Root)/examples/dotnet/

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/.pipelines/ci.local.sh
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/Dockerfile
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/work.sln
  Assert_File_Exists $(Files_Path_Root)/examples/dotnet/app1/src/work.csproj
}