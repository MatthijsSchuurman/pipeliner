#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/misc.sh

UnitTest_explode() {
  #Given
  local string="a,b,c"
  local delimiter=,

  #When
  local result=($(explode "$delimiter" "$string"))

  #Then
  Assert_Equal "${result[0]}" a
  Assert_Equal "${result[1]}" b
  Assert_Equal "${result[2]}" c


  #Given
  local string="a&&b b&&c"
  local delimiter="&&"

  #When
  IFS=$'\n' read -d '' -ra result < <(explode "$delimiter" "$string")
  for element in "${result[@]}"; do
    echo "Element: $element"
  done

  #Then
  Assert_Equal "${result[0]}" a
  Assert_Equal "${result[1]}" "b b"
  Assert_Equal "${result[2]}" c
}

UnitTest_implode() {
  #Given
  local delimiter=,

  #When
  local result=$(implode "$delimiter" a b c)

  #Then
  Assert_Equal "$result" "a,b,c"


  #Given
  local delimiter="&&"

  #When
  local result=$(implode $delimiter a "b b" c)

  #Then
  Assert_Equal "$result" "a&&b b&&c"
}

UnitTest_trim() {
  #Given
  local string="  a b c  "

  #When
  local result=$(trim "$string")

  #Then
  Assert_Equal "$result" "a b c"


  #Given
  local string="a b c"

  #When
  local result=$(trim "$string")

  #Then
  Assert_Equal "$result" "a b c"


  #Given
  local string="-e"

  #When
  local result=$(trim "$string")

  #Then
  Assert_Equal "$result" "-e"
}

UnitTest_toLower() {
  #Given
  local string="A B C"

  #When
  local result=$(toLower "$string")

  #Then
  Assert_Equal "$result" "a b c"


  #Given
  local string="Just a random String!"

  #When
  local result=$(toLower "$string")

  #Then
  Assert_Equal "$result" "just a random string!"
}

UnitTest_toUpper() {
  #Given
  local string="a b c"

  #When
  local result=$(toUpper "$string")

  #Then
  Assert_Equal "$result" "A B C"


  #Given
  local string="Just a random String!"

  #When
  local result=$(toUpper "$string")

  #Then
  Assert_Equal "$result" "JUST A RANDOM STRING!"
}

UnitTest_map() {
  #Given
  local array=(a b c)

  prepend() {
    echo a$1
  }

  #When
  local result=($(map prepend ${array[@]}))

  #Then
  Assert_Equal ${#result[@]} 3
  Assert_Equal ${result[0]} aa
  Assert_Equal ${result[1]} ab
  Assert_Equal ${result[2]} ac
}

UnitTest_reduce() {
  #Given
  local array=(1 2 3 4 5)

  sum() {
    if [ ! $2 ]; then
      echo $1
    else
      echo $(($1 + $2))
    fi
  }

  #When
  local result=$(reduce sum ${array[@]})

  #Then
  Assert_Equal $result 15
}

UnitTest_filter() {
  #Given
  local array=(1 2 3 4 5)

  isEven() {
    if [ $(($1 % 2)) -eq 0 ]; then
      echo $1
    fi
  }

  #When
  local result=($(filter isEven ${array[@]}))

  #Then
  Assert_Equal ${#result[@]} 2
  Assert_Equal ${result[0]} 2
  Assert_Equal ${result[1]} 4
}

UnitTest_reverse() {
  #Given
  local array=(1 2 3 4 5)

  #When
  local result=($(reverse ${array[@]}))

  #Then
  Assert_Equal ${#result[@]} 5
  Assert_Equal ${result[0]} 5
  Assert_Equal ${result[1]} 4
  Assert_Equal ${result[2]} 3
  Assert_Equal ${result[3]} 2
  Assert_Equal ${result[4]} 1
}