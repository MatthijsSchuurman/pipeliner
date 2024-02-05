#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh

UnitTest_Log_Debug() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Debug "debug message")

  #Then
  Assert_Contains "$actual" "DEBUG" "debug message"
}
UnitTest_Log_Debug_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Debug "debug message")

  #Then
  Assert_Contains "$actual" "##[debug]" "debug message"
}
UnitTest_Log_Debug_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Debug "debug message" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging for unknown platform is not supported"
}

UnitTest_Log_Info() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Info "info message")

  #Then
  Assert_Contains "$actual" "INFO" "info message"
}
UnitTest_Log_Info_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Info "info message")

  #Then
  Assert_Contains "$actual" "##[info]" "info message"
}
UnitTest_Log_Info_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Info "info message" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging for unknown platform is not supported"
}

UnitTest_Log_Warning() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Warning "warning message")

  #Then
  Assert_Contains "$actual" "WARN" "warning message"
}
UnitTest_Log_Warning_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Warning "warning message")

  #Then
  Assert_Contains "$actual" "##[warning]" "warning message"
}
UnitTest_Log_Warning_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Warning "warning message" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging for unknown platform is not supported"
}


UnitTest_Log_Error() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Error "error message")

  #Then
  Assert_Contains "$actual" "ERROR" "error message"
}
UnitTest_Log_Error_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Error "error message")

  #Then
  Assert_Contains "$actual" "##[error]" "error message"
}
UnitTest_Log_Error_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Error "error message" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging for unknown platform is not supported"
}

UnitTest_Log_Variable() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Variable "key" "value")

  #Then
  Assert_Contains "$actual" "VARIABLE" "key=value"
}
UnitTest_Log_Variable_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Variable "key" "value")

  #Then
  Assert_Contains "$actual" "##vso[task.setvariable variable=key]value"
}
UnitTest_Log_Variable_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Variable "key" "value" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Logging variables for unknown platform is not supported"
}

UnitTest_Log_Group() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Group "group message")

  #Then
  Assert_Contains "$actual" "GROUP" "group message"
}
UnitTest_Log_Group_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Group "group message")

  #Then
  Assert_Contains "$actual" "##[group]" "group message"
}
UnitTest_Log_Group_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Group "group message" 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Log grouping for unknown platform is not supported"
}

UnitTest_Log_Group_End() {
  #Given
  Environment_Platform() { #mock
    echo "local"
  }

  #When
  local actual=$(Log_Group_End)

  #Then
  Assert_Contains "$actual" "ENDGROUP"
}
UnitTest_Log_Group_End_Azure() {
  #Given
  Environment_Platform() { #mock
    echo "azure"
  }

  #When
  local actual=$(Log_Group_End)

  #Then
  Assert_Equal "$actual" "##[endgroup]"
}
UnitTest_Log_Group_End_Fail() {
  #Given
  local actual=
  local exitCode=

  Environment_Platform() { #mock
    echo "unknown"
  }

  #When
  actual=$(Log_Group_End 2>&1)
  exitCode=$?

  #Then
  Assert_Match $exitCode 1
  Assert_Match "$actual" "Log grouping for unknown platform is not supported"
}