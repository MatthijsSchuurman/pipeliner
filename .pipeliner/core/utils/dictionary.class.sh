#!/bin/bash

Dictionary_Exists() {
  local dictionary=$1
  local key=$2

  local match=$(echo "$key" | sed -E 's/(\-|\{|\}|\(|\)|\[|\]|\|)/\\\1/g')
  grep "^$match: *" <<< "$dictionary" > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    return 0
  fi

  return 1
}

Dictionary_Keys() {
  local dictionary=$1

  grep -E "[^\n:]+:" <<< "$dictionary" | sed -E "s/(.*):.*/\1/"
}

Dictionary_Set() {
  local dictionary=$1
  local key=$2
  local value=$3

  if [[ "$key" == *$'\n'* ]]; then
    echo "Dictionary key '$key' contains new line character" >&2
    return 1
  elif [[ "$key" == *:* ]]; then
    echo "Dictionary key '$key' contains colon character" >&2
    return 1
  fi

  if [[ "$value" == *$'\n'* ]]; then
    echo "Dictionary value '$value' contains new line character" >&2
    return 1
  fi

  if [ "$dictionary" ]; then
    dictionary+="\n"
  fi

  if Dictionary_Exists "$dictionary" "$key"; then #update
    local match=$(echo "$key" | sed -E 's/(\-|\{|\}|\(|\)|\[|\]|\|)/\\\1/g')
    echo -e "$dictionary" | sed -E "s/^${match//\//\\/}: *.*/${key//\//\\/}: ${value//\//\\/}/"
  else #add
    echo -e "$dictionary$key: $value"
  fi
}


Dictionary_Unset() {
  local dictionary=$1
  local key=$2

  if [[ "$key" == *$'\n'* ]]; then
    echo "Dictionary key '$key' contains new line character" >&2
    return 1
  elif [[ "$key" == *:* ]]; then
    echo "Dictionary key '$key' contains colon character" >&2
    return 1
  fi

  if ! Dictionary_Exists "$dictionary" "$key"; then
    echo "Dictionary key '$key' not found" >&2
    return 1
  fi

  local match=$(echo "$key" | sed -E 's/(\-|\{|\}|\(|\)|\[|\]|\|)/\\\1/g')
  echo -e "$dictionary" | grep --invert-match "^$match: *.*" 2> /dev/null
  return 0
}

Dictionary_Get() {
  local dictionary=$1
  local key=$2

  local pair=

  if [[ "$key" == *$'\n'* ]]; then
    echo "Dictionary key '$key' contains new line character" >&2
    return 1
  elif [[ "$key" == *:* ]]; then
    echo "Dictionary key '$key' contains colon character" >&2
    return 1
  fi

  local match=$(echo "$key" | sed -E 's/(\-|\{|\}|\(|\)|\[|\]|\|)/\\\1/g')
  pair=$(grep "^$match: *" <<< "$dictionary" 2> /dev/null)
  if [ $? -ne 0 ]; then
    echo "Dictionary key '$key' not found" >&2
    return 1
  fi

  echo "$pair" | sed -E "s/.*: *(.*)/\1/" | sed -E "s/\"(.*)\"/\1/"
}
