#!/bin/bash

source $(Files_Path_Pipeliner)/core/misc.sh
source $(Files_Path_Pipeliner)/core/colors.sh
source $(Files_Path_Pipeliner)/core/dictionary.sh
source $(Files_Path_Pipeliner)/core/log.sh

CLI_Arguments() {
  local definition=$(CLI_Arguments__Parse_Mapping "$1")
  shift
  local arguments=("$@")

  local failures=0
  local result=

  for argument in "${arguments[@]}"; do
    if Dictionary_Exists "$definition" "$argument"; then
      if [ "$key" ]; then
        local index=0
        while Dictionary_Exists "$result" "$key,$index" ; do
          index=$((index+1))
        done

        result=$(Dictionary_Set "$result" "$key,$index" TRUE)
      fi

      key=$(Dictionary_Get "$definition" "$argument")
    elif [ ${argument:0:1} == "-" ]; then
      Log_Error "Unknown argument: $argument" >&2
      failures=$((failures+1))
    elif [ "$key" ]; then
      local index=0
      while Dictionary_Exists "$result" "$key,$index" ; do
        index=$((index+1))
      done

      result=$(Dictionary_Set "$result" "$key,$index" "$argument")
      unset key
    else
      local index=0
      while Dictionary_Exists "$result" "$index" ; do
        index=$((index+1))
      done

      result=$(Dictionary_Set "$result" "$index" "$argument")
    fi
  done

  if [ "$key" ]; then
    local index=0
    while Dictionary_Exists "$result" "$key,$index" ; do
      index=$((index+1))
    done

    result=$(Dictionary_Set "$result" "$key,$index" TRUE)
  fi

  if [ $failures != 0 ]; then
    result=$(Dictionary_Set "$result" "FAILURES" "$failures")
  fi

  echo "$result"
}

CLI_Arguments_Usage() {
  local script=$1
  local definition=$2

  echo "Usage: $(Color_Blue $script) [$(Color_White options)]"

  IFS=$'\n'
  for line in $definition; do
    local argument=$(echo "$line" | sed -E "s/^([^:]*):.*$/\1/")
    local comment=$(echo "$line" | sed -E "s/^[^:]*: *[^#]*#(.*)/\1/")

    argument=$(trim "$argument")
    comment=$(trim "$comment")

    if [ "$argument" ]; then
      echo " $(Color_White $argument): $comment"
    fi
  done
}

CLI_Arguments__Parse_Mapping() {
  local definition=$1
  local result=

  IFS=$'\n'
  for line in $definition; do
    local argument=$(echo "$line" | sed -E "s/^([^:]*):.*$/\1/")
    local key=$(echo "$line" | sed -E "s/^[^:]*: *([^#]*).*/\1/")

    argument=$(trim "$argument")
    key=$(trim "$key")
    if [ "$argument" ] && [ "$key" ]; then
      Dictionary_Set "$result" "$argument" "$key"
    fi
  done

  echo "$result"
}