#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/azdo.class.sh
source $(Files_Path_Pipeliner)/core/utils/files.class.sh

UnitTest_AZDO_Agent_Latest() {
  #Given
  local actual=
  local exitCode=

  wget() { #mock to prevent rate limiting to ruin the test
    echo '{"tag_name": "v3.234.0"}'
  }

  #When
  actual=$(AZDO_Agent_Latest)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "^[0-9]+\.[0-9]+\.[0-9]+$"
}

UnitTest_AZDO_Agent_Download() {
  #Given
  local actual=
  local exitCode=
  local filename=

  wget() { #mock to prevent rate limiting to ruin the test
    echo "downloaded" > azdo-agent-v3.234.0.tar.gz
    return 0
  }
  AZDO_Agent_Latest() { #mock
    echo "3.234.0"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Download > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" GROUP "Downloading AZDO Agent 3.234.0" ENDGROUP

  filename=$(Variables_Get "azdoAgentFilename")
  Assert_Equal "$filename" "azdo-agent-v3.234.0.tar.gz"
  Assert_File_Exists "$filename"

  #Cleanup
  rm -f "$filename"
}

UnitTest_AZDO_Agent_Download_Fail() {
  #Given
  local actual=
  local exitCode=
  rm -f "azdo-agent-vinvalid.tar.gz"

  wget() { #mock to prevent rate limiting to ruin the test
    echo "failed"
    return 8
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Download invalid > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 8
  Assert_Contains "$actual" GROUP "Downloading AZDO Agent invalid" ENDGROUP
  Assert_Contains "$actual" ERROR "Failed to download AZDO Agent invalid"
  Variables_Get "azdoAgentFilename" 2> /dev/null
  Assert_Equal $? 1
}

UnitTest_AZDO_Agent_Install() {
  #Given
  local exitCode=
  local filename=$(Files_Temp_File test .tar.gz)
  local directory=$(Files_Temp_Directory test)

  touch "$directory/svc.sh"
  tar -czf "$filename" -C "$directory" .
  rm -Rf "$directory"

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Install "$filename" "$directory" > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists "$directory"
  Assert_File_Exists "$directory/svc.sh"

  #Cleanup
  rm -Rf "$filename" "$directory"
}

UnitTest_AZDO_Agent_Install_Fail() {
  #Given
  local exitCode=
  local filename=invalid.tar.gz
  local directory=$(Files_Temp_Directory test)

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Install "$filename" "$directory" > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" ERROR "File not found: $filename"
  Variables_Get "azdoAgentFilename" 2> /dev/null
  Assert_Equal $? 1

  #Cleanup
  rm -Rf "$directory"


  #Given
  filename=$(Files_Temp_File test .tar.gz)
  directory=$(Files_Temp_Directory test)

  #When
  logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Install "$filename" "$directory" > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" ERROR "Directory already exists: $directory"

  #Cleanup
  rm -Rf "$filename" "$directory"


  #Given
  filename=$(Files_Temp_File test .tar.gz)
  directory=$(Files_Temp_Directory test)

  rm -Rf "$directory"

  #When
  logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Install "$filename" > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Contains "$actual" ERROR "Invalid AZDO Agent file: $filename"

  #Cleanup
  rm -Rf "$filename" "$directory"
}