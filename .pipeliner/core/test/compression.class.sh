#!/bin/bash

source $(Files_Path_Pipeliner)/core/compression.class.sh

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
  Assert_Contains "$actual" GROUP "Zipping $filename"
  Assert_Contains "$actual" adding compression.class.sh
  Assert_Contains "$actual" ENDGROUP

  rm -f "$filename"


  #Given
  local files="$(Files_Path_Pipeliner)/core/compression.class.sh $(Files_Path_Pipeliner)/core/log.class.sh"

  #When
  actual=$(Compression_Zip $filename $files)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Zipping $filename"
  Assert_Contains "$actual" adding compression.class.sh
  Assert_Contains "$actual" adding log.class.sh
  Assert_Contains "$actual" ENDGROUP
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
  Assert_Contains "$actual" GROUP "Zipping $filename"
  Assert_Contains "$actual" adding core/compression.class.sh
  Assert_Contains "$actual" adding test.sh
  Assert_Contains "$actual" ENDGROUP

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
  Assert_Contains "$actual" GROUP "Zipping $filename"
  Assert_Contains "$actual" Zipping failed
  Assert_Contains "$actual" ENDGROUP

  rm -f "$filename"
}
