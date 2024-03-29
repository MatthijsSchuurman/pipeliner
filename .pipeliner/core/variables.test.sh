#!/bin/bash

source $(Files_Path_Pipeliner)/core/variables.sh

UnitTest_Variables_Set() {
  #Given
  local key="key"
  local value="value"
  local value2="value2"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Set "$key" "$value" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$(Dictionary_Get "$PIPELINER_VARIABLES" "$key")" "$value"
  Assert_Match "$actual" "VARIABLE $key=$value"

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Set "$key" "$value2" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$(Dictionary_Get "$PIPELINER_VARIABLES" "$key")" "$value2"
  Assert_Match "$actual" "VARIABLE $key=$value2"
  Assert_Match "$actual" "Overwriting variable $key"
}
UnitTest_Variables_Set_Fail() {
  #Given
  local key=
  local value="value"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Set "$key" "$value" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Variable key is not set"


  #Given
  local key="key"
  local value=

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Set "$key" "$value" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Variable value is not set"
}

UnitTest_Variables_Unset() {
  #Given
  local key="key"
  local value="value"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  Variables_Set "$key" "$value"

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Unset "$key" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "VARIABLE $key="
  Assert_Equal "$(Dictionary_Get "$PIPELINER_VARIABLES" "$key" 2> /dev/null)" ""
}

UnitTest_Variables_Unset_Fail() {
  #Given
  local key="key"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Unset "$key" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Variable $key is not set"


  #Given
  local key=

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Unset "$key" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Variable key is not set"
}


UnitTest_Variables_Get() {
  #Given
  local key="key"
  local value="value"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  Variables_Set "$key" "$value"

  #When
  actual=$(Variables_Get "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal $actual "$value"
}

UnitTest_Variables_Get_Fail() {
  #Given
  local key="key"

  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Get "$key" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Variable $key is not set"


  #Given
  local key=

  #When
  local logFile=$(Files_Temp_File test .log)
  Variables_Get "$key" > $logFile 2>&1
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Variable key is not set"
}