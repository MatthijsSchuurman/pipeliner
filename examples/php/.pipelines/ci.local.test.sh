#!/bin/bash

E2ETest_Examples_PHP_Pipeline_CI() {
  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Root)/examples/php/.pipelines/ci.local.sh examples/php/app1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0

  if [ $(Environment_Platform) == "local" ]; then
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
  else
    Assert_Match "$actual" debug "Docker version [0-9\.]+"
    Assert_Contains "$actual" warning "Running CI pipeline for examples/php/app1"
    Assert_Contains "$actual" group "Docker Build ./.pipeliner/php/Dockerfile"
    Assert_Contains "$actual" info "Composer PHPUnit Test"
    Assert_Contains "$actual" group "Docker Run php:runner phpunit test"
    Assert_Contains "$actual" info "PHP Lint"
    Assert_Contains "$actual" group "Docker Run php:runner php -l ."
    Assert_Contains "$actual" info "Composer Install packages"
    Assert_Contains "$actual" group "Docker Run php:runner composer install --no-dev"
    Assert_Contains "$actual" group "Docker Build Dockerfile examples/php/app1"
    Assert_Contains "$actual" info "CI pipline for examples/php/app1 done"
  fi
}