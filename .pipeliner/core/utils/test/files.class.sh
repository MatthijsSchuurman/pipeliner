#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/files.class.sh

UnitTest_Files_Path_Original() {
  local currentDirectory=$(pwd)
  #Given

  #When
  local path=$(Files_Path_Original)

  #Then
  Assert_Equal "$path" "."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../.." #go to root directory

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
  cd "$(dirname ${BASH_SOURCE[0]})/../../../.." #go to root directory

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
  Assert_Starts_With "$path" "../../.."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Root)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../.."
}

UnitTest_Files_Path_Work() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../.." #go to root directory

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "."


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core/utils

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" ".pipeliner/core/utils"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Work)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "examples/node"
}

UnitTest_Files_Path_Pipeliner() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../.." #go to root directory

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
  Assert_Starts_With "$path" "../../../../.pipeliner"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Pipeliner)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner"
}

UnitTest_Files_Path_Data() {
  local currentDirectory=$(pwd)
  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../.." #go to root directory

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "./.pipeliner/data"
  Assert_Directory_Exists "$(dirname ${BASH_SOURCE[0]})/../../../../$path"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})" #.pipeliner/core/utils

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../../../.pipeliner/data"


  #Given
  cd "$(dirname ${BASH_SOURCE[0]})/../../../../examples/node" #examples/node

  #When
  local path=$(Files_Path_Data)
  cd $currentDirectory #go back to current directory

  #Then
  Assert_Starts_With "$path" "../../.pipeliner/data"
  Assert_Directory_Exists "$(dirname ${BASH_SOURCE[0]})/../../../../examples/node/$path"
}


# Files get / import

UnitTest_Files_Get_Class_Files() {
  #Given

  #When
  local files=$(Files_Get_Class_Files)

  #Then
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/utils/assert.class.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/utils/colors.class.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/utils/files.class.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/utils/test.class.sh"
}

UnitTest_Files_Import_Classes() {
  #Given

  #When
  Files_Import_Classes

  #Then
  Assert_Not_Equal "$(type -t Color_Red)" ""
  Assert_Not_Equal "$(type -t Color_Green)" ""
  Assert_Not_Equal "$(type -t Color_Yellow)" ""
  Assert_Not_Equal "$(type -t Assert_Equal)" ""
  Assert_Not_Equal "$(type -t Assert_Starts_With)" ""
  Assert_Not_Equal "$(type -t Assert_Ends_With)" ""
  Assert_Not_Equal "$(type -t Assert_Contains)" ""
  Assert_Not_Equal "$(type -t Assert_Not_Equal)" ""
  Assert_Not_Equal "$(type -t Assert_Empty)" ""
  Assert_Not_Equal "$(type -t Test_Run)" ""
  Assert_Not_Equal "$(type -t Files_Get_Class_Files)" ""
  Assert_Not_Equal "$(type -t Files_Import_Classes)" ""
}

UnitTest_Files_Get_Stage_Files() {
  #Given

  #When
  local files=$(Files_Get_Stage_Files)

  #Then
  Assert_Contains "$files" "$(Files_Path_Root)/examples/node/.pipelines/build.stage.sh"
  Assert_Contains "$files" "$(Files_Path_Root)/examples/node/.pipelines/test.stage.sh"
}


UnitTest_Files_Import_Stages() {
  #Given

  #When
  Files_Import_Stages

  #Then
  Assert_Not_Equal "$(type -t Node_Pipelines_Stage_Build)" ""
  Assert_Not_Equal "$(type -t Node_Pipelines_Stage_Test)" ""
}

UnitTest_Files_Get_Test_Files() {
  #Given

  #When
  local files=$(Files_Get_Test_Files)

  #Then
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/utils/test/assert.class.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/core/test/log.class.sh"
  Assert_Contains "$files" "$(Files_Path_Pipeliner)/test/init.sh"
}

UnitTest_Files_Import_Tests() {
  #Given

  #When
  Files_Import_Tests

  #Then
  Assert_Not_Equal "$(type -t UnitTest_Files_Get_Class_Files)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Import_Classes)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Get_Test_Files)" ""
  Assert_Not_Equal "$(type -t UnitTest_Files_Import_Tests)" ""
}


UnitTest_Files_Get_Unit_Tests() {
  #Given

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/core/utils/test/test.class.sh)

  #Then
  Assert_Contains "$unittests" UnitTest_Example

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/core/utils/test/files.class.sh)

  #Then
  Assert_Contains "$unittests" "UnitTest_Files_Get_Class_Files"
  Assert_Contains "$unittests" "UnitTest_Files_Import_Classes"
  Assert_Contains "$unittests" "UnitTest_Files_Get_Test_Files"
  Assert_Contains "$unittests" "UnitTest_Files_Import_Tests"

  #When
  local unittests=$(Files_Get_Unit_Tests $(Files_Path_Pipeliner)/test.sh)

  #Then
  Assert_Empty "$unittests"
}

UnitTest_Files_Get_Integration_Tests() {
  #Given

  #When
  local integrationtests=$(Files_Get_Integration_Tests $(Files_Path_Pipeliner)/core/utils/test/test.class.sh)

  #Then
  Assert_Contains "$integrationtests" IntegrationTest_Example

  #When
  local integrationtests=$(Files_Get_Integration_Tests $(Files_Path_Pipeliner)/test.sh)

  #Then
  Assert_Empty "$integrationtests"
}

UnitTest_Files_Get_E2E_Tests() {
  #Given

  #When
  local e2etests=$(Files_Get_E2E_Tests $(Files_Path_Pipeliner)/core/utils/test/test.class.sh)

  #Then
  Assert_Contains "$e2etests" E2ETest_Example

  #When
  local e2etests=$(Files_Get_E2E_Tests $(Files_Path_Pipeliner)/test.sh)

  #Then
  Assert_Empty "$e2etests"
}


# Files watch

UnitTest_Files_Watch_Directory_Written() {
  #Given
  local directory=tmp
  rm -rf $directory 2>&1 > /dev/null
  mkdir $directory

  #When
  UnitTest_Files_Watch_Directory_Written_thread(){
    sleep 1
    touch $directory/test.txt
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
