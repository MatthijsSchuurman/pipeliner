#!/bin/bash

source $(Files_Path_Pipeliner)/php/php.sh

PHP_Composer_Install() {
  local workdir=$1
  local production=$2

  Log_Info "Composer Install packages"
  if [ "$production" ]; then
    PHP_Run "$workdir" "composer install --no-dev"
  else
    PHP_Run "$workdir" "composer install"
  fi
}

PHP_Composer_Test() {
  local workdir=$1

  Log_Info "Composer PHPUnit Test"
  PHP_Run "$workdir" "composer install" "vendor/bin/phpunit test --log-junit test-report.xml"
}