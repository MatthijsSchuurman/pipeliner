#!/bin/bash

source $(Files_Path_Pipeliner)/php/composer.sh

UnitTest_PHP_Composer_Install() {
  #Given
  local workdir=examples/php/app1
  local production=
  local actual=
  local exitCode=

  rm -rf $(Files_Path_Root)/$workdir/vendor/

  #When
  PHP_Composer_Install $workdir $production
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/vendor/
  Assert_File_Exists $(Files_Path_Root)/$workdir/vendor/autoload.php
  Assert_File_Exists $(Files_Path_Root)/$workdir/vendor/bin/phpunit

  #Clean
  rm -rf $(Files_Path_Root)/$workdir/vendor/
}

UnitTest_PHP_Composer_Install_Production() {
  #Given
  local workdir=examples/php/app1
  local production=true
  local actual=
  local exitCode=

  rm -rf $(Files_Path_Root)/$workdir/vendor/

  #When
  PHP_Composer_Install $workdir $production
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists $(Files_Path_Root)/$workdir/vendor/
  Assert_File_Exists $(Files_Path_Root)/$workdir/vendor/autoload.php
  Assert_Not_File_Exists $(Files_Path_Root)/$workdir/vendor/bin/phpunit

  #Clean
  rm -rf $(Files_Path_Root)/$workdir/vendor/
}

UnitTest_PHP_Composer_Test() {
  #Given
  local workdir=examples/php/app1
  local actual=
  local exitCode=

  PHP_Composer_Install $workdir

  #When
  PHP_Composer_Test $workdir
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_File_Exists $(Files_Path_Root)/$workdir/test-report.xml

  #Clean
  rm -f $(Files_Path_Root)/$workdir/test-report.xml
}