#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/colors.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh

Log__Log() {
  local level=$1
  local message=$2

  case $(Environment_Platform) in
    "azure")
      echo "##[${level,,}] $message"
      ;;
    "github")
      echo "::${level,,}::$message"
      ;;
    "local")
      local log="$level $message"

      case $level in
        "DEBUG")   Color_Gray "$log" ; echo ;;
        "INFO")    Color_White "$log" ; echo ;;
        "WARNING") Color_Yellow "$log" ; echo ;;
        "ERROR")   Color_Red "$log" ; echo ;;
        *)         echo "$log" ;;
      esac
      ;;
    *)
      echo "Logging for $(Environment_Platform) platform is not supported" >&2
      exit 1
      ;;
  esac
}

Log_Debug() {
  local message=$1
  Log__Log "DEBUG" "$message"
}

Log_Info() {
  local message=$1
  Log__Log "INFO" "$message"
}

Log_Warning() {
  local message=$1
  Log__Log "WARNING" "$message"
}

Log_Error() {
  local message=$1
  Log__Log "ERROR" "$message"
}

Log_Variable() {
  local key=$1
  local value=$2

  case $(Environment_Platform) in
    "azure")
      echo "##vso[task.setvariable variable=$key]$value"
      ;;
    "github")
      echo "$key=$value" >> "$GITHUB_OUTPUT"
      ;;
    "local")
      Color_Cyan "VARIABLE $key=$value" ; echo
      ;;
    *)
      echo "Logging variables for $(Environment_Platform) platform is not supported" >&2
      exit 1
      ;;
  esac
}


Log_Group() {
  local name=$1

  case $(Environment_Platform) in
    "azure")  echo "##[group] $name" ;;
    "github") echo "::group::$name" ;;
    "local")  Color_Blue "GROUP $name" ; echo ;;
    *)
      echo "Log grouping for $(Environment_Platform) platform is not supported" >&2
      exit 1
      ;;
  esac
}

Log_Group_End() {
  case $(Environment_Platform) in
    "azure")  echo "##[endgroup]" ;;
    "github") echo "::endgroup::" ;;
    "local")  Color_Blue "ENDGROUP" ; echo ;;
    *)
      echo "Log grouping for $(Environment_Platform) platform is not supported" >&2
      exit 1
      ;;
  esac
  echo
}