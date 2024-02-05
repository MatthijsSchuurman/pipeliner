#!/bin/bash

source $(Files_Path_Pipeliner)/core/environment.class.sh

UnitTest_Environment_Platform() {
  #Given

  #When
  local actual=$(Environment_Platform)

  #Then
  Assert_Equal "$actual" "local"
}

UnitTest_Environment_OS() {
  #Given
  OSTYPE="linux-gnu"

  #When
  local actual=$(Environment_OS)

  #Then
  Assert_Equal "$actual" "linux"


  #Given
  OSTYPE="darwin"

  #When
  local actual=$(Environment_OS)

  #Then
  Assert_Equal "$actual" "macos"


  #Given
  OSTYPE="msys"

  #When
  local actual=$(Environment_OS)

  #Then
  Assert_Equal "$actual" "windows"
}

UnitTest_Environment_Distro() {
  #Given

  #When
  local actual=$(Environment_Distro)

  #Then
  if [ -f /etc/os-release ]; then
    Assert_Not_Empty "$actual"
  else
    Assert_Empty "$actual"
  fi
}

UnitTest_Environment_Architecture() {
  #Given

  #When
  local actual=$(Environment_Architecture)

  #Then
  Assert_Equal "$actual" "$(uname -m)"
}

UnitTest_Environment_Package_Manager() {
  #Given

  #When
  local actual=$(Environment_Package_Manager)

  #Then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    Assert_Equal "$actual" "brew"
  else
    Assert_Equal "$actual" "pacman"
  fi
}