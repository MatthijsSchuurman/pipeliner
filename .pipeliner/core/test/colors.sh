#!/bin/bash

source $(Files_Path_Pipeliner)/core/colors.sh

UnitTest_Color_Green() {
  #Given
  local expected=$(echo -e "\033[1;32mHello\033[0m")

  #When
  local actual=$(Color_Green "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Red() {
  #Given
  local expected=$(echo -e "\033[1;31mHello\033[0m")

  #When
  local actual=$(Color_Red "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Yellow() {
  #Given
  local expected=$(echo -e "\033[1;33mHello\033[0m")

  #When
  local actual=$(Color_Yellow "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Blue() {
  #Given
  local expected=$(echo -e "\033[1;34mHello\033[0m")

  #When
  local actual=$(Color_Blue "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Purple() {
  #Given
  local expected=$(echo -e "\033[1;35mHello\033[0m")

  #When
  local actual=$(Color_Purple "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Cyan() {
  #Given
  local expected=$(echo -e "\033[1;36mHello\033[0m")

  #When
  local actual=$(Color_Cyan "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_White() {
  #Given
  local expected=$(echo -e "\033[1;37mHello\033[0m")

  #When
  local actual=$(Color_White "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Gray() {
  #Given
  local expected=$(echo -e "\033[0;90mHello\033[0m")

  #When
  local actual=$(Color_Gray "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}

UnitTest_Color_Grey() {
  #Given
  local expected=$(echo -e "\033[1;90mHello\033[0m")

  #When
  local actual=$(Color_Grey "Hello")

  #Then
  Assert_Equal "$actual" "$expected"
}