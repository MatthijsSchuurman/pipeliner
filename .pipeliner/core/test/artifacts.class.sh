#!/bin/bash

source $(Files_Path_Pipeliner)/core/artifacts.class.sh

UnitTest_Artifacts_Directory() {
  #Given
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  actual=$(Artifacts_Directory)

  #Then
  Assert_Match "$actual" "artifacts"
  Assert_Directory_Exists "$actual"

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Directory_Azure() {
  #Given
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="test/artifacts/"
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  actual=$(Artifacts_Directory)

  #Then
  Assert_Match "$actual" "$BUILD_ARTIFACTSTAGINGDIRECTORY"
  Assert_Directory_Exists "$actual"

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Directory_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Artifacts_Directory 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging for unknown platform is not supported"
}

UnitTest_Artifacts_Write() {
  #Given
  local fileName="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  actual=$(Artifacts_Write "$fileName" "$content")

  Assert_File_Exists "$(Artifacts_Directory)/$fileName"
  Assert_Equal "$(cat $(Artifacts_Directory)/$fileName)" "$content"
  Assert_Match "$actual" "Writing artifact '$fileName'"

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Write_Azure() {
  #Given
  local fileName="test.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="test/artifacts/"
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  actual=$(Artifacts_Write "$fileName" "$content")

  Assert_File_Exists "$BUILD_ARTIFACTSTAGINGDIRECTORY/$fileName"
  Assert_Equal "$(cat $BUILD_ARTIFACTSTAGINGDIRECTORY/$fileName)" "$content"
  Assert_Match "$actual" "Writing artifact '$fileName'"

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Delete() {
  #Given
  local fileName="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  Artifacts_Write "$fileName" "$content"
  actual=$(Artifacts_Delete "$fileName")

  Assert_Not_File_Exists "$(Artifacts_Directory)/$fileName"
  Assert_Match "$actual" "Deleting artifact '$fileName'"

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Delete_Azure() {
  #Given
  local fileName="test.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="test/artifacts/"
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  Artifacts_Write "$fileName" "$content"
  actual=$(Artifacts_Delete "$fileName")

  Assert_Not_File_Exists "$BUILD_ARTIFACTSTAGINGDIRECTORY/$fileName"
  Assert_Match "$actual" "Deleting artifact '$fileName'"

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}