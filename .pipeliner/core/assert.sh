#!/bin/bash


# String assertions

Assert_Equal() {
  local actual=$1
  local expected=$2

  if [ "$actual" != "$expected" ]; then
    echo "Assert failed: expected '$actual' to equal '$expected'"
    exit 1
  fi
}
Assert_Not_Equal() {
  local actual=$1
  local expected=$2

  if [ "$actual" == "$expected" ]; then
    echo "Assert failed: expected '$actual' to not equal '$expected'"
    exit 1
  fi
}

Assert_Greater_Than() {
  local actual=$1
  local expected=$2

  if [ ! "$actual" -gt "$expected" ]; then
    echo "Assert failed: expected '$actual' to be greater than '$expected'"
    exit 1
  fi
}
Assert_Greater_Than_Or_Equal() {
  local actual=$1
  local expected=$2

  if [ ! "$actual" -ge "$expected" ]; then
    echo "Assert failed: expected '$actual' to be greater than or equal to '$expected'"
    exit 1
  fi
}

Assert_Less_Than() {
  local actual=$1
  local expected=$2

  if [ ! "$actual" -lt "$expected" ]; then
    echo "Assert failed: expected '$actual' to be less than '$expected'"
    exit 1
  fi
}
Assert_Less_Than_Or_Equal() {
  local actual=$1
  local expected=$2

  if [ ! "$actual" -le "$expected" ]; then
    echo "Assert failed: expected '$actual' to be less than or equal to '$expected'"
    exit 1
  fi
}

Assert_Between() {
  local min=$1
  local actual=$2
  local max=$3

  if [ ! "$min" -le "$actual" -o ! "$actual" -lt "$max" ]; then
    echo "Assert failed: expected '$actual' to be between '$min' and '$max'"
    exit 1
  fi
}
Assert_Not_Between() {
  local min=$1
  local actual=$2
  local max=$3

  if [ "$actual" -ge "$min" ] && [ "$actual" -le "$max" ]; then
    echo "Assert failed: expected '$actual' to not be between '$min' and '$max'"
    exit 1
  fi
}

Assert_Match() {
  local actual=$1
  local expected=$2

  if [[ ! "$actual" =~ $expected ]]; then
    echo "Assert failed: expected '$actual' to match '$expected'"
    exit 1
  fi
}
Assert_Not_Match() {
  local actual=$1
  local expected=$2

  if [[ "$actual" =~ $expected ]]; then
    echo "Assert failed: expected '$actual' to not match '$expected'"
    exit 1
  fi
}

Assert_Starts_With() {
  local actual=$1
  local expected=$2

  if [[ ! "$actual" == "$expected"* ]]; then
    echo "Assert failed: expected '$actual' to start with '$expected'"
    exit 1
  fi
}
Assert_Not_Starts_With() {
  local actual=$1
  local expected=$2

  if [[ "$actual" == "$expected"* ]]; then
    echo "Assert failed: expected '$actual' to not start with '$expected'"
    exit 1
  fi
}

Assert_Ends_With() {
  local actual=$1
  local expected=$2

  if [[ ! "$actual" == *"$expected" ]]; then
    echo "Assert failed: expected '$actual' to end with '$expected'"
    exit 1
  fi
}
Assert_Not_Ends_With() {
  local actual=$1
  local expected=$2

  if [[ "$actual" == *"$expected" ]]; then
    echo "Assert failed: expected '$actual' to not end with '$expected'"
    exit 1
  fi
}

Assert_Contains() {
  local actual=$1
  shift 1
  local expected=$@

  for item in $expected; do
    if [[ "$actual" != *"$item"* ]]; then
      echo "Assert failed: expected '$actual' to contain '$item'"
      exit 1
    fi
  done
}
Assert_Not_Contains() {
  local actual=$1
  shift 1
  local expected=$@

  for item in $expected; do
    if [[ "$actual" == *"$item"* ]]; then
      echo "Assert failed: expected '$actual' to not contain '$item'"
      exit 1
    fi
  done
}

Assert_Empty() {
  local actual=$1

  if [ "$actual" ]; then
    echo "Assert failed: expected '$actual' to be empty"
    exit 1
  fi
}
Assert_Not_Empty() {
  local actual=$1

  if [ ! "$actual" ]; then
    echo "Assert failed: expected '$actual' to not be empty"
    exit 1
  fi
}


# File assertions

Assert_File_Exists() {
  local file=$1

  if [ ! -f "$file" ]; then
    echo "Assert failed: expected file '$file' to exist"
    exit 1
  fi
}

Assert_Not_File_Exists() {
  local file=$1

  if [ -f "$file" ]; then
    echo "Assert failed: expected file '$file' to not exist"
    exit 1
  fi
}

Assert_File_Contains() {
  local file=$1
  local expected=$2

  if [ ! -f "$file" ]; then
    echo "Assert failed: expected file '$file' to exist"
    exit 1
  fi

  if ! grep -q "$expected" "$file"; then
    echo "Assert failed: expected file '$file' to contain '$expected'"
    exit 1
  fi
}

Assert_File_Not_Contains() {
  local file=$1
  local expected=$2

  if [ ! -f "$file" ]; then
    echo "Assert failed: expected file '$file' to exist"
    exit 1
  fi

  if grep -q "$expected" "$file"; then
    echo "Assert failed: expected file '$file' to not contain '$expected'"
    exit 1
  fi
}

Assert_Directory_Exists() {
  local directory=$1

  if [ ! -d "$directory" ]; then
    echo "Assert failed: expected directory '$directory' to exist"
    exit 1
  fi
}

Assert_Not_Directory_Exists() {
  local directory=$1

  if [ -d "$directory" ]; then
    echo "Assert failed: expected directory '$directory' to not exist"
    exit 1
  fi
}

Assert_Path_Owner() {
  local path=$1
  local owner=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    local actual=$(stat -f '%u' $path)
  else
    local actual=$(stat --format '%u' $path)
  fi

  if [ "$actual" != "$owner" ]; then
    echo "Assert failed: expected path '$path' to be owned by '$owner'"
    exit 1
  fi
}

Assert_Path_Group() {
  local path=$1
  local group=$2

  if [[ "$OSTYPE" == "darwin"* ]]; then
    local actual=$(stat -f '%g' $path)
  else
    local actual=$(stat --format '%g' $path)
  fi

  if [ "$actual" != "$group" ]; then
    echo "Assert failed: expected path '$path' to be owned by '$group'"
    exit 1
  fi
}


# Misc assertions

Assert_Function() {
  local function=$1

  type $function > /dev/null 2>&1

  if [ $? -ne 0 ]; then
    echo "Assert failed: expected function '$function' to exist"
    exit 1
  fi
}
