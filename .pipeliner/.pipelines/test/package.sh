#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/package.class.sh

IntegrationTest_Pipeliner_Package_Filename() {
  #Given
  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  #When
  local actual=$(Pipeliner_Package_Filename)

  #Then
  Assert_Match "$actual" "pipeliner-1.2.345-test.zip"
}

IntegrationTest_Pipeliner_Package_Create() {
  #Given
  local actual=
  local exitCode=

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }
  Artifacts_Directory() { #mock
    echo "artifacts-test"
  }

  rm -rf "$(Artifacts_Directory)"
  mkdir -p "$(Artifacts_Directory)"
  rm -f $(Files_Path_Root)/pipeliner-1.2.345-test.zip

  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Package_Create > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Preparing build directory"
  Assert_Match "$actual" "Creating package"
  Assert_Match "$actual" "Removing build directory"

  Assert_Match "$(Variables_Get package)" "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip"
  Assert_File_Exists "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip"

  #check file size
  local size=$(stat -c%s "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip" 2>/dev/null || stat -f%z "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip" 2>/dev/null)
  Assert_Between 150000 $size 200000

  #check contents
  files=$(unzip -l "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip" | awk '{print $4}')
  Assert_Contains "$files" ".pipeliner/init.sh"
  Assert_Contains "$files" ".pipeliner/core/log.class.sh"
  Assert_Contains "$files" ".pipeliner/README.md"
  Assert_Contains "$files" ".pipeliner/LICENSE.md"
  Assert_Contains "$files" ".vscode/settings.json"
  Assert_Contains "$files" ".github/workflows/ci.yml"
  Assert_Contains "$files" ".azuredevops/ci.yml"
  Assert_Contains "$files" "examples/dotnet/app1/work.sln"
  Assert_Contains "$files" "examples/jvm/app-kotlin/build.gradle"
  Assert_Contains "$files" "examples/node/.pipelines/ci.local.sh"
  Assert_Contains "$files" "examples/php/app1/src/index.php"
  Assert_Contains "$files" "Vagrantfile"

  Assert_Not_Contains "$(echo "$files" | grep "^README.md$")" "README.md" #should be removed from root
  Assert_Not_Contains "$(echo "$files" | grep "^LICENSE.md$")" "LICENSE.md" #should be removed from root

  #Clean
  rm -rf "$(Artifacts_Directory)"
}