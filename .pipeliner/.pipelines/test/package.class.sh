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

  Environment_Platform() { #mock
    echo "local"
  }
  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }
  VCS_Clone_Directory() { #mock
    local source=$1
    local target=$2

    mkdir -p "$target"
    cp -r "$source/.pipeliner" "$target"
    cp -r "$source/.vscode" "$target"
    cp *.md "$target"

    rsync -a --exclude=.nuget/ --exclude=.local/ --exclude=.dotnet/ --exclude=bin/ --exclude=obj/ --exclude=.npm/ --exclude=node_modules/ "$source/examples" "$target"
  }

  rm -rf $(Artifacts_Directory)


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
  Assert_Between 50000 $size 150000

  #check contents
  files=$(unzip -l "$(Artifacts_Directory)/packages/pipeliner-1.2.345-test.zip" | awk '{print $4}')
  Assert_Contains "$files" ".pipeliner/init.sh"
  Assert_Contains "$files" ".pipeliner/core/log.class.sh"
  Assert_Contains "$files" ".pipeliner/README.md"
  Assert_Contains "$files" ".pipeliner/LICENSE.md"
  Assert_Contains "$files" "examples/node/.pipelines/ci.local.sh"
  Assert_Contains "$files" "examples/dotnet/app1/work.sln"

  Assert_Not_Contains "$(echo "$files" | grep "^README.md$")" "README.md" #should be removed from root
  Assert_Not_Contains "$(echo "$files" | grep "^LICENSE.md$")" "LICENSE.md" #should be removed from root


  #Clean
  rm -rf $(Artifacts_Directory)
}