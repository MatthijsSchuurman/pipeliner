#!/bin/bash

explode() {
  local delimiter=$1
  local string=$2

  local entry=
  IFS=$delimiter read -ra result <<< "$string"
  for entry in "${result[@]}"; do
    echo "$entry"
  done
}

implode() {
  local delimiter=$1
  shift
  local array=("$@")

  local result=""
  for item in "${array[@]}"; do
    result+="$item$delimiter"
  done

  echo ${result%$delimiter}
}

trim() {
  local string=$1

  sed -E "s/^ +| +$//g" <<< $string
}

map() {
  local callback=$1
  shift
  local array=("$@")

  local result=()
  for item in "${array[@]}"; do
    result+=($(eval "$callback $item"))
  done

  echo "${result[@]}"
}

reduce() {
  local callback=$1
  shift
  local array=("$@")

  local result=()
  for item in "${array[@]}"; do
    result=$(eval "$callback $item $result")
  done

  echo $result
}

filter() {
  local callback=$1
  shift
  local array=("$@")

  local result=()
  for item in "${array[@]}"; do
    if [ $(eval "$callback $item") ]; then
      result+=($item)
    fi
  done

  echo "${result[@]}"
}

reverse() {
  local array=("$@")

  local result=()
  for ((i=${#array[@]}-1; i>=0; i--)); do
    result+=(${array[i]})
  done

  echo "${result[@]}"
}