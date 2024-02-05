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
  VCS_Clone_Directory() { #mock
    local source=$1
    local target=$2

    mkdir -p "$target"
    cp -r "$source/.pipeliner" "$target"
    cp -r "$source/.vscode" "$target"

    rsync -a --exclude=.nuget/ --exclude=.local/ --exclude=.dotnet/ --exclude=bin/ --exclude=obj/ --exclude=.npm/ --exclude=node_modules/ "$source/examples" "$target"
  }

  #When
  Pipeliner_Package_Create > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Preparing build directory"
  Assert_Match "$actual" "Creating package"
  Assert_Match "$actual" "Removing build directory"

  Assert_Match "$(Variables_Get package)" "$(Files_Path_Root)/pipeliner-1.2.345-test.zip"
  Assert_File_Exists $(Files_Path_Root)/pipeliner-1.2.345-test.zip

  #check file size
  local size=$(stat -c%s "$(Files_Path_Root)/pipeliner-1.2.345-test.zip" 2>/dev/null || stat -f%z "$(Files_Path_Root)/pipeliner-1.2.345-test.zip" 2>/dev/null)
  Assert_Between 50000 $size 150000

  #check contents
  files=$(unzip -l $(Files_Path_Root)/pipeliner-1.2.345-test.zip | awk '{print $4}')
  Assert_Contains "$files" ".pipeliner/init.sh"
  Assert_Contains "$files" ".pipeliner/core/log.class.sh"
  Assert_Contains "$files" "examples/node/.pipelines/ci.local.sh"
  Assert_Contains "$files" "examples/dotnet/app1/work.sln"

  #Clean
  rm $(Files_Path_Root)/pipeliner-1.2.345-test.zip
}