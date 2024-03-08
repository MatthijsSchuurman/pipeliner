#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/dictionary.class.sh
source $(Files_Path_Pipeliner)/core/environment.class.sh
source $(Files_Path_Pipeliner)/core/log.class.sh

PIPELINER_VARIABLES=

Variables_Set() {
  local key=$1
  local value=$2

  if [ ! "$key" ]; then
    Log_Error "Variable key is not set" >&2
    return 1
  fi

  if [ ! "$value" ]; then
    Log_Error "Variable value is not set" >&2
    return 1
  fi


  if Dictionary_Exists "$PIPELINER_VARIABLES" "$key"; then
    Log_Warning "Overwriting variable $key"
  fi

  PIPELINER_VARIABLES=$(Dictionary_Set "$PIPELINER_VARIABLES" "$key" "$value")
  Log_Variable "$key" "$value"
}

Variables_Unset() {
  local key=$1

  if [ ! "$key" ]; then
    Log_Error "Variable key is not set" >&2
    return 1
  fi

  if ! Dictionary_Exists "$PIPELINER_VARIABLES" "$key" ; then
    Log_Warning "Variable $key is not set"
    return 0
  fi

  PIPELINER_VARIABLES=$(Dictionary_Unset "$PIPELINER_VARIABLES" "$key")
  Log_Variable "$key" ""
}

Variables_Get() {
  local key=$1

  if [ ! "$key" ]; then
    Log_Error "Variable key is not set" >&2
    return 1
  fi

  if ! Dictionary_Exists "$PIPELINER_VARIABLES" "$key" ; then
    Log_Error "Variable $key is not set" >&2
    return 1
  fi

  Dictionary_Get "$PIPELINER_VARIABLES" "$key"
}
