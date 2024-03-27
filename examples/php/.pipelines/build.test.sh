#!/bin/bash

IntegrationTest_Examples_PHP_Stage_Build() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  PHP_Pipelines_Stage_Build examples/php/app1

  #Then
  actual=$(Docker_List examples/php/app1:latest)
  Assert_Contains "$actual" "examples/php/app1" "latest"

  actual=$(Docker_Run examples/php/app1:latest "" "" "php --version")
  Assert_Match "$actual" "[0-9]+\.[0-9]+\.[0-9]+"

  Docker_Run examples/php/app1:latest "" "" "test -f /home/www-data/app/composer.json"
  Assert_Equal $? 0
  Docker_Run examples/php/app1:latest "" "" "test -d /home/www-data/app/src/"
  Assert_Equal $? 0
  Docker_Run examples/php/app1:latest "" "" "test -f /home/www-data/app/vendor/autoload.php"
  Assert_Equal $? 0
  Docker_Run examples/php/app1:latest "" "" "test -f /home/www-data/app/vendor/bin/phpunit"
  Assert_Equal $? 1
}
