#!/bin/bash

E2ETest_Examples_PHP_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  local logFile=$(Files_Temp_File test .log)
  source $(Files_Path_Root)/examples/php/.pipelines/ci.local.sh examples/php/app1 > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" DEBUG "Docker version [0-9\.]+"
  Assert_Contains "$actual" "WARNING Running CI pipeline for examples/php/app1"
  Assert_Contains "$actual" "GROUP Docker Build ./.pipeliner/php/Dockerfile"
  Assert_Contains "$actual" "INFO Composer PHPUnit Test"
  Assert_Contains "$actual" "GROUP Docker Run php:runner phpunit test"
  Assert_Contains "$actual" "INFO PHP Lint"
  Assert_Contains "$actual" "GROUP Docker Run php:runner php -l ."
  Assert_Contains "$actual" "INFO Composer Install packages"
  Assert_Contains "$actual" "GROUP Docker Run php:runner composer install --no-dev"
  Assert_Contains "$actual" "GROUP Docker Build Dockerfile examples/php/app1"
  Assert_Contains "$actual" "INFO CI pipline for examples/php/app1 done"
}