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

  BUILD_ARTIFACTSTAGINGDIRECTORY="$(Files_Path_Root)/artifacts"
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

UnitTest_Artifacts_Directory_Github() {
  #Given
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }

  #When
  actual=$(Artifacts_Directory)

  #Then
  Assert_Match "$actual" "artifacts"
  Assert_Directory_Exists "$actual"

  #Clean
  rm -rf "artifacts"
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
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  actual=$(Artifacts_Write "$filename" "$content")

  Assert_File_Exists "$(Artifacts_Directory)/$filename"
  Assert_Equal "$(cat $(Artifacts_Directory)/$filename)" "$content"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Writing artifact $filename"
  else
    Assert_Match "$actual" info "Writing artifact $filename"
  fi

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Write_Azure() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="$(Files_Path_Root)/artifacts"
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  actual=$(Artifacts_Write "$filename" "$content")

  Assert_File_Exists "$BUILD_ARTIFACTSTAGINGDIRECTORY/$filename"
  Assert_Equal "$(cat $BUILD_ARTIFACTSTAGINGDIRECTORY/$filename)" "$content"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Writing artifact $filename"
  else
    Assert_Match "$actual" info "Writing artifact $filename"
  fi

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Write_Github() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }

  #When
  actual=$(Artifacts_Write "$filename" "$content")

  Assert_File_Exists "$(Artifacts_Directory)/$filename"
  Assert_Equal "$(cat $(Artifacts_Directory)/$filename)" "$content"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Writing artifact $filename"
  else
    Assert_Match "$actual" info "Writing artifact $filename"
  fi

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Read() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  echo "$content" > "$(Artifacts_Directory)/$filename"

  #When
  actual=$(Artifacts_Read "$filename")

  Assert_Equal "$actual" "$content"

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Read_Azure() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="test/artifacts/"
  Environment_Platform() { #mock
    echo "azure"
  }

  mkdir -p "$BUILD_ARTIFACTSTAGINGDIRECTORY"
  echo "$content" > "$BUILD_ARTIFACTSTAGINGDIRECTORY/$filename"

  #When
  actual=$(Artifacts_Read "$filename")

  Assert_Equal "$actual" "$content"

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Read_Github() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }

  echo "$content" > "$(Artifacts_Directory)/$filename"

  #When
  actual=$(Artifacts_Read "$filename")

  Assert_Equal "$actual" "$content"

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Read_Fail() {
  #Given
  local filename="test.txt"
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  actual=$(Artifacts_Read "$filename" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" ERROR "Artifact $filename does not exist"
  else
    Assert_Match "$actual" error "Artifact $filename does not exist"
  fi
}

UnitTest_Artifacts_Move() {
  #Given
  local sourceFilename="test.txt"
  local destinationFilename="test2.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  echo "$content" > "$sourceFilename"

  #When
  actual=$(Artifacts_Move "$sourceFilename" "$destinationFilename")

  Assert_File_Exists "$(Artifacts_Directory)/$destinationFilename"
  Assert_Not_File_Exists "$sourceFilename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Moving artifact $sourceFilename to $(Artifacts_Directory)/$destinationFilename"
  else
    Assert_Match "$actual" info "Moving artifact $sourceFilename to $(Artifacts_Directory)/$destinationFilename"
  fi

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Move_Azure() {
  #Given
  local sourceFilename="test.txt"
  local destinationFilename="test2.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="$(Files_Path_Root)/artifacts"
  Environment_Platform() { #mock
    echo "azure"
  }

  echo "$content" > "$sourceFilename"

  #When
  actual=$(Artifacts_Move "$sourceFilename" "$destinationFilename")

  Assert_File_Exists "$BUILD_ARTIFACTSTAGINGDIRECTORY/$destinationFilename"
  Assert_Not_File_Exists "$sourceFilename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Moving artifact $sourceFilename to $BUILD_ARTIFACTSTAGINGDIRECTORY/$destinationFilename"
  else
    Assert_Match "$actual" info "Moving artifact $sourceFilename to $BUILD_ARTIFACTSTAGINGDIRECTORY/$destinationFilename"
  fi

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Move_Github() {
  #Given
  local sourceFilename="test.txt"
  local destinationFilename="test2.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }

  echo "$content" > "$sourceFilename"

  #When
  actual=$(Artifacts_Move "$sourceFilename" "$destinationFilename")

  Assert_File_Exists "$(Artifacts_Directory)/$destinationFilename"
  Assert_Not_File_Exists "$sourceFilename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Moving artifact $sourceFilename to $(Artifacts_Directory)/$destinationFilename"
  else
    Assert_Match "$actual" info "Moving artifact $sourceFilename to $(Artifacts_Directory)/$destinationFilename"
  fi

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Move_Fail() {
  #Given
  local sourceFilename="test.txt"
  local destinationFilename="test2.txt"
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  actual=$(Artifacts_Move "$sourceFilename" "$destinationFilename" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" ERROR "Artifact $sourceFilename does not exist"
  else
    Assert_Match "$actual" error "Artifact $sourceFilename does not exist"
  fi
}

UnitTest_Artifacts_Delete() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  Artifacts_Write "$filename" "$content"
  actual=$(Artifacts_Delete "$filename")

  Assert_Not_File_Exists "$(Artifacts_Directory)/$filename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Deleting artifact $filename"
  else
    Assert_Match "$actual" info "Deleting artifact $filename"
  fi

  #Clean
  rm -rf "artifacts"
}

UnitTest_Artifacts_Delete_Azure() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  BUILD_ARTIFACTSTAGINGDIRECTORY="$(Files_Path_Root)/artifacts"
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  Artifacts_Write "$filename" "$content"
  actual=$(Artifacts_Delete "$filename")

  Assert_Not_File_Exists "$BUILD_ARTIFACTSTAGINGDIRECTORY/$filename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Deleting artifact $filename"
  else
    Assert_Match "$actual" info "Deleting artifact $filename"
  fi

  #Clean
  rm -rf "$BUILD_ARTIFACTSTAGINGDIRECTORY"
}

UnitTest_Artifacts_Delete_Github() {
  #Given
  local filename="test.txt"
  local content="test content"
  local actual=

  Environment_Platform() { #mock
    echo "github"
  }

  #When
  Artifacts_Write "$filename" "$content"
  actual=$(Artifacts_Delete "$filename")

  Assert_Not_File_Exists "$(Artifacts_Directory)/$filename"

  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" INFO "Deleting artifact $filename"
  else
    Assert_Match "$actual" info "Deleting artifact $filename"
  fi

  #Clean
  rm -rf "artifacts"
}