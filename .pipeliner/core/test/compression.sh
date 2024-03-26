#!/bin/bash

source $(Files_Path_Pipeliner)/core/compression.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh

UnitTest_Compression_Zip() {
  #Given
  local filename="test.zip"
  local files="$(Files_Path_Pipeliner)/core/compression.class.sh"
  local actual=
  local exitCode=

  rm -f "$filename"

  #When
  actual=$(Compression_Zip $filename $files)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping $filename" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping $filename" endgroup
  fi

  Assert_File_Exists "$filename"
  Assert_Contains "$actual" adding compression.class.sh

  #Clean
  rm -f "$filename"


  #Given
  filename="test2.zip"
  files="$(Files_Path_Pipeliner)/core/compression.class.sh $(Files_Path_Pipeliner)/core/log.class.sh"

  rm -f "$filename"

  #When
  actual=$(Compression_Zip $filename $files)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping $filename" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping $filename" endgroup
  fi

  Assert_File_Exists "$filename"
  Assert_Contains "$actual" adding compression.class.sh
  Assert_Contains "$actual" adding log.class.sh

  #Clean
  rm -f "$filename"
}

UnitTest_Compression_Zip_Directory() {
  #Given
  local filename="test.zip"
  local files="$(Files_Path_Pipeliner)"
  local actual=
  local exitCode=

  rm -f "$filename"

  #When
  actual=$(Compression_Zip $filename $files)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping $filename" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping $filename" endgroup
  fi

  Assert_File_Exists "$filename"
  Assert_Contains "$actual" adding core/compression.class.sh
  Assert_Contains "$actual" adding test.sh

  #Clean
  rm -f "$filename"
}

UnitTest_Compression_Zip_Fail() {
  #Given
  local filename="test.zip"
  local files="NON_EXISTING_FILE"
  local actual=
  local exitCode=

  rm -f "$filename"

  #When
  actual=$(Compression_Zip $filename $files)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 12
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Zipping $filename" ENDGROUP
  else
    Assert_Contains "$actual" group "Zipping $filename" endgroup
  fi

  Assert_Not_File_Exists "$filename"
  Assert_Contains "$actual" Zipping failed
}
