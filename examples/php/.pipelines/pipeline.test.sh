#!/bin/bash

IntegrationTest_Examples_PHP_Pipelines_Affected_all() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  local actual=$(PHP_Pipelines_Affected "#all")

  #Then
  Assert_Contains "$actual" examples/php/app1 examples/php/app2
}

IntegrationTest_Examples_PHP_Pipelines_Affected_affected() {
  #Given
  source $(Files_Path_Pipeliner)/init

  VCS_Affected_Directories() { #mock
    echo "examples/php/app1"
  }

  #When
  local actual=$(PHP_Pipelines_Affected "#affected")
  echo $actual

  #Then
  Assert_Contains "$actual" examples/php/app1
  Assert_Not_Contains "$actual" examples/php/app2
}