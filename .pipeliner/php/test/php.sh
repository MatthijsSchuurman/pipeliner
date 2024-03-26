#!/bin/bash

source $(Files_Path_Pipeliner)/php/php.class.sh

UnitTest_PHP_Dockerfile() {
  #Given
  local actual=
  local exitCode=
  local tools=(ls php composer)

  #When
  for tool in ${tools[@]}; do
    Docker_Runner php "" "" "which $tool"
    exitCode=$?

    #Then
    Assert_Equal $exitCode 0
  done


  #When
  actual=$(Docker_Runner php "" "" "php --version")

  #Then
  Assert_Match "$actual" "PHP 8\.3\.[0-9]+"


  #When
  actual=$(Docker_Runner php "" "" "composer --version")

  #Then
  Assert_Match "$actual" Composer version "[0-9]+\.[0-9]+\.[0-9]+"
}

UnitTest_PHP_Run() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/php

  #When
  actual=$(PHP_Run $workdir "php --version")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "PHP [0-9]+\.[0-9]+\.[0-9]+"

  #When
  actual=$(PHP_Run $workdir "composer --version" "ls -la")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" Composer version "[0-9]+\.[0-9]+\.[0-9]+" examples drwx
}

UnitTest_PHP_Lint() {
  #Given
  local actual=
  local exitCode=
  local workdir=examples/php/app1

  #When
  actual=$(PHP_Lint $workdir)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_File_Exists "$(Files_Path_Root)/$workdir/lint-report.txt"

  local report=$(cat "$(Files_Path_Root)/$workdir/lint-report.txt")
  Assert_Contains "$report" "No syntax errors detected" src/index.php src/HelloWorld.php test/HelloWorldTest.php

  #Clean
  rm "$(Files_Path_Root)/$workdir/lint-report.txt"
}