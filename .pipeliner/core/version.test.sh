#!/bin/bash

source $(Files_Path_Pipeliner)/core/version.sh

UnitTest_Version_Pipeliner() {
  #Given
  local version=25.5

  #When
  local actual=$(Version_Pipeliner)

  #Then
  Assert_Equal $actual $version
}

UnitTest_Version_Pipeliner_Full() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }
  Version_Pipeliner() { #mock
    echo 1.0
  }
  Version_BuildId_Next() { #mock
    PIPELINER_BUILDID=123
  }

  #When
  Version_BuildId_Next
  local actual=$(Version_Pipeliner_Full)

  #Then
  Assert_Equal $actual 1.0.123
}

UnitTest_Version_Pipeliner_Code() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }
  Version_Pipeliner() { #mock
    echo 1.2
  }
  Version_BuildId_Next() { #mock
    PIPELINER_BUILDID=345
  }

  #When
  Version_BuildId_Next
  local actual=$(Version_Pipeliner_Code)

  #Then
  Assert_Equal $actual 10200345
}

UnitTest_Version_BuildId() {
  #Given
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }
  Version_BuildId_Next() { #mock
    PIPELINER_BUILDID=123
  }

  #When
  Version_BuildId_Next
  actual=$(Version_BuildId)

  #Then
  Assert_Equal $actual 123

  #When
  actual2=$(Version_BuildId)

  #Then
  Assert_Equal $actual $actual2
}

UnitTest_Version_BuildId_Azure() {
  #Given
  local actual=

  Environment_Platform() { #mock
    echo "azure"
  }
  BUILD_BUILDID=123 #mock

  #When
  actual=$(Version_BuildId)

  #Then
  Assert_Equal "$actual" 123
}

UnitTest_Version_BuildId_Github() {
  #Given
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }
  GITHUB_RUN_NUMBER=123 #mock

  #When
  actual=$(Version_BuildId)

  #Then
  Assert_Equal "$actual" 123
}

UnitTest_Version_BuildId_Fail() {
  #Given
  Environment_Platform() { #mock
    echo "unknown"
  }
  Log_Error () { #mock
    echo "$1" >&2
  }

  #When
  actual=$(Version_BuildId 2>&1)

  #Then
  Assert_Match "$actual" "Version BuildId for unknown platform is not supported"
}


UnitTest_Version_BuildId_Next() {
  if [ "$(Environment_Platform)" != "local" ]; then exit 255; fi #skip

  #Given
  local currentBuildId=$(cat $(Files_Path_Data)/.buildId 2> /dev/null || echo 0)
  local expectedBuildId=$((currentBuildId+1))

  #When
  Version_BuildId_Next

  #Then
  Assert_Equal $PIPELINER_BUILDID $expectedBuildId
}

UnitTest_Version_Generate_BuildId_NewFile() {
  if [ "$(Environment_Platform)" != "local" ]; then exit 255; fi #skip

  #Given
  mv $(Files_Path_Data)/.buildId $(Files_Path_Data)/.buildId.bak

  #When
  Version_BuildId_Next
  mv $(Files_Path_Data)/.buildId.bak $(Files_Path_Data)/.buildId

  #Then
  Assert_Equal $PIPELINER_BUILDID 1
}

UnitTest_Version_BuildId_Next_Fail() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  actual=$(Version_BuildId_Next 2>&1)

  #Then
  Assert_Match "$actual" "Version BuildId Next is only supported for local platform"
}
