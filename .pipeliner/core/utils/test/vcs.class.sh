#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/vcs.class.sh

UnitTest_VCS_Affected() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local directory=$(Files_Path_Root)/test
  rm -rf $directory 2>&1 > /dev/null
  mkdir $directory
  touch $directory/test.txt

  if [ -d $(Files_Path_Root)/.git ]; then
    git add --intent-to-add $directory/test.txt
  fi

  #When
  local files=$(VCS_Affected)

  if [ -d $(Files_Path_Root)/.git ]; then
    git rm --force $directory/test.txt
  fi

  #Then
  Assert_Contains "$files" test/test.txt

  #Clean
  rm -rf $directory 2>&1 > /dev/null
}

UnitTest_VCS_Affected_Directories() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local directory=$(Files_Path_Root)/test/test
  rm -rf $directory 2>&1 > /dev/null
  mkdir -p $directory
  touch $directory/test.txt
  touch $directory/test2.txt

  if [ -d $(Files_Path_Root)/.git ]; then
    git add --intent-to-add $directory/test.txt
  fi

  #When
  local directories=$(VCS_Affected_Directories)

  if [ -d $(Files_Path_Root)/.git ]; then
    git rm --force $directory/test.txt
  fi

  #Then
  Assert_Contains "$directories" test/test


  #Given
  rm -rf $directory 2>&1 > /dev/null
  mkdir -p $directory
  touch $directory/test.txt
  touch $directory/test2.txt

  if [ -d $(Files_Path_Root)/.git ]; then
    git add --intent-to-add $directory/test.txt
  fi

  #When
  local directories=$(VCS_Affected_Directories "" 1)

  if [ -d $(Files_Path_Root)/.git ]; then
    git rm --force $directory/test.txt
  fi

  #Then
  Assert_Contains "$directories" test
  Assert_Not_Contains "$directories" test/test

  #Clean
  rm -rf $(Files_Path_Root)/test 2>&1 > /dev/null
}

UnitTest_VCS_Clone_Directory() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local source=$(Files_Path_Root)
  local target=$(Files_Path_Root)/test
  local exitCode=

  rm -rf "$target" 2>&1 > /dev/null

  #When
  actual=$(VCS_Clone_Directory "$source" "$target")
  exitCode=$?

  echo "$actual"
  echo $exitCode

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Cloning repository .+ to .+test.+"
  if [ -d $(Files_Path_Root)/.hg ]; then
    Assert_Directory_Exists "$target/.hg"
  else
    Assert_Directory_Exists "$target/.git"
  fi

  Assert_Directory_Exists "$target/.pipeliner"

  #Clean
  rm -rf "$target" 2>&1 > /dev/null
}

UnitTest_VCS_Clone_Directory_Update() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local source=$(Files_Path_Root)
  local target=$(Files_Path_Root)/test
  local exitCode=

  rm -rf "$target" 2>&1 > /dev/null
  VCS_Clone_Directory "$source" "$target"

  local currentPath=$(pwd)
  cd "$target"
  git checkout main 2>&1 > /dev/null
  cd "$currentPath"

  #When
  actual=$(VCS_Clone_Directory "$source" "$target")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Updating repository .+test.+"
  if [ -d $(Files_Path_Root)/.hg ]; then
    Assert_Directory_Exists "$target/.hg"
  else
    Assert_Directory_Exists "$target/.git"
  fi
  Assert_Directory_Exists "$target/.pipeliner"

  #Clean
  rm -rf "$target" 2>&1 > /dev/null
}

UnitTest_VCS_Clone_Directory_Unknown() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local source=$(Files_Path_Root)/test
  local target=$(Files_Path_Root)/test2
  local exitCode=

  rm -rf "$source" 2>&1 > /dev/null
  rm -rf "$target" 2>&1 > /dev/null
  mkdir -p "$source"

  #When
  actual=$(VCS_Clone_Directory "$source" "$target" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Unknown version control system"

  #Clean
  rm -rf "$source" 2>&1 > /dev/null
  rm -rf "$target" 2>&1 > /dev/null
}
