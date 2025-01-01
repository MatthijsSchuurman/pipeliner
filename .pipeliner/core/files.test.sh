#!/bin/bash

source $(Files_Path_Pipeliner)/core/files.sh

UnitTest_Files_Path_Original() {
  local currentDirectory=$(pwd)
  #Given

  #When
  local path=$(Files_Path_Original)

  #Then
  Assert_Equal "$path" "."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../.." #go to root directory

  #When
  local path=$(Files_Path_Original)
  local expected=$(realpath --relative-to "$(pwd)" "$ORIGINALPWD")

  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "$expected"
}

UnitTest_Files_Path_Root() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../.." #go to root directory

  #When
  local path=$(Files_Path_Root)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core/utils

  #When
  local path=$(Files_Path_Root)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../.."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Root)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../.."
}

UnitTest_Files_Path_Work() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../.." #go to root directory

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" ".pipeliner/core"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "examples/node"
}

UnitTest_Files_Path_Pipeliner() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../.." #go to root directory

  #When
  local path=$(Files_Path_Pipeliner)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "./.pipeliner"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core/utils

  #When
  local path=$(Files_Path_Pipeliner)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Pipeliner)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner"
}

UnitTest_Files_Path_Data() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../.." #go to root directory

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "./.pipeliner/data"
  Assert_Directory_Exists "$(dirname ${BASH_SOURCE[0]})/../../$path"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core/utils

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner/data"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner/data"
  Assert_Directory_Exists "$(dirname ${BASH_SOURCE[0]})/../../examples/node/$path"
}


# Files get / import

UnitTest_Files_Get_Module_Files() {
  #Given

  #When
  local files=$(Files_Get_Module_Files)

  #Then
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/assert.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/colors.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/files.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/test.sh"
}

UnitTest_Files_Pre_Import_Modules() {
  #Given

  #When
  Files_Pre_Import_Modules

  #Then
  Assert_Equal "$(type -t Color_Red)" "function"
  Assert_Equal "$(type -t Files_Get_Module_Files)" "function"
  Assert_Equal "$(type -t Vagrant_Up)" "function"
  Assert_Equal "$(type -t zip)" "file"

  Assert_Not_Contains "$(declare -f Color_Red)" source colors.sh
  Assert_Not_Contains "$(declare -f Files_Get_Module_Files)" source files.sh
  Assert_Contains "$(declare -f SSH_Directory)" SSH_Directory source ssh.sh #not yet initialised
}

UnitTest_Files_Import_Modules() {
  #Given

  #When
  Files_Import_Modules

  #Then
  Assert_Equal "$(type -t Color_Red)" "function"
  Assert_Equal "$(type -t Files_Get_Module_Files)" "function"
  Assert_Equal "$(type -t Vagrant_Up)" "function"
  Assert_Equal "$(type -t zip)" "file"

  Assert_Not_Contains "$(declare -f Color_Red)" source colors.sh
  Assert_Not_Contains "$(declare -f Files_Get_Module_Files)" source files.sh
  Assert_Not_Contains "$(declare -f Vagrant_Up)" source vagrant.sh
}

UnitTest_Files_Get_Test_Files() {
  #Given

  #When
  local files=$(Files_Get_Test_Files)

  #Then
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/assert.test.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/log.test.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/init.test"
}

UnitTest_Files_Import_Tests() {
  #Given

  #When
  Files_Import_Tests

  #Then
  Assert_Not_Equal "$(type -t UnitTest_Files_Get_Module_Files)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Import_Modules)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Get_Test_Files)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Import_Tests)" ""
}


UnitTest_Files_Get_Unit_Tests() {
  #Given

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/core/test.test.sh)

  #Then
  Assert_Contains "$unittests" UnitTest_Example

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/core/files.test.sh)

  #Then
  Assert_Contains "$unittests" "UnitTest_Files_Get_Module_Files"
  Assert_Contains "$unittests" "UnitTest_Files_Import_Modules"
  Assert_Contains "$unittests" "UnitTest_Files_Get_Test_Files"
  Assert_Contains "$unittests" "UnitTest_Files_Import_Tests"

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/test)

  #Then
  Assert_Empty "$unittests"
}

UnitTest_Files_Get_Integration_Tests() {
  #Given

  #When
  local integrationtests=$(Files_Get_Integration_Tests $(Files_Path_Pipeliner)/core/test.test.sh)

  #Then
  Assert_Contains "$integrationtests" IntegrationTest_Example

  #When
  local integrationtests=$(Files_Get_Integration_Tests $(Files_Path_Pipeliner)/test)

  #Then
  Assert_Empty "$integrationtests"
}

UnitTest_Files_Get_E2E_Tests() {
  #Given

  #When
  local e2etests=$(Files_Get_E2E_Tests $(Files_Path_Pipeliner)/core/test.test.sh)

  #Then
  Assert_Contains "$e2etests" E2ETest_Example

  #When
  local e2etests=$(Files_Get_E2E_Tests $(Files_Path_Pipeliner)/test)

  #Then
  Assert_Empty "$e2etests"
}


# Files watch

UnitTest_Files_Watch_Directory_Written() {
  if [ ! -x "$(command -v inotifywait)" ] && [ ! -x "$(command -v fswatch)" ]; then exit 255 ; fi #skip

  #Given
  local directory=tmp
  rm -rf $directory 2>&1 > /dev/null
  mkdir $directory
  sync

  #When
  UnitTest_Files_Watch_Directory_Written_thread(){
    sleep 1
    echo "test" > $directory/test.txt
  }
  UnitTest_Files_Watch_Directory_Written_thread &

  local file=
  file=$(Files_Watch_Directory_Written $directory)

  #Then
  Assert_Equal $? 0
  Assert_Contains "$file" $directory/test.txt

  #Clean
  rm -rf $directory 2>&1 > /dev/null
}


# Files temp

UnitTest_Files_Temp__Dir() {
  #Given

  #When
  local directory=$(Files_Temp__Dir)

  #Then
  Assert_Equal $directory "/tmp/pipeliner"
  Assert_Directory_Exists $directory
}

UnitTest_Files_Temp_File() {
  #Given

  #When
  local file1=$(Files_Temp_File)

  #Then
  Assert_Match $file1 "/tmp/pipeliner/.*"
  Assert_File_Exists $file1

  #Clean
  rm -f $file1


  #When
  local file2=$(Files_Temp_File)
  local file3=$(Files_Temp_File)

  #Then
  Assert_Not_Equal $file1 $file2
  Assert_Not_Equal $file2 $file3

  #Clean
  rm -f $file2 $file3
}
UnitTest_Files_Temp_File_Prefix_Suffix() {
  #Given

  #When
  local file1=$(Files_Temp_File "prefix" "suffix")

  #Then
  Assert_Match $file1 "/tmp/pipeliner/prefix.*suffix"
  Assert_File_Exists $file1

  #Clean
  rm -f $file1
}

UnitTest_Files_Temp_Directory() {
  #Given

  #When
  local directory1=$(Files_Temp_Directory)

  #Then
  Assert_Match $directory1 "/tmp/pipeliner/.*"
  Assert_Directory_Exists $directory1

  #Clean
  rm -rf $directory1


  #When
  local directory2=$(Files_Temp_Directory)
  local directory3=$(Files_Temp_Directory)

  #Then
  Assert_Not_Equal $directory1 $directory2
  Assert_Not_Equal $directory2 $directory3

  #Clean
  rm -rf $directory2 $directory3
}
UnitTest_Files_Temp_Directory_Prefix_Suffix() {
  #Given

  #When
  local directory1=$(Files_Temp_Directory "prefix" "suffix")

  #Then
  Assert_Match $directory1 "/tmp/pipeliner/prefix.*suffix"
  Assert_Directory_Exists $directory1

  #Clean
  rm -rf $directory1
}

UnitTest_Files_Temp_Clean() {
  #Given
  local directory=$(Files_Temp__Dir)
  local file=$(Files_Temp_File)
  local directory2=$(Files_Temp_Directory)

  #When
  Files_Temp_Clean

  #Then
  Assert_Not_Directory_Exists $directory
  Assert_Not_File_Exists $file
  Assert_Not_Directory_Exists $directory2
}
