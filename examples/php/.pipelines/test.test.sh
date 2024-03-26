#!/bin/bash

IntegrationTest_Examples_PHP_Pipelines_Stage_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init

  #When
  PHP_Pipelines_Stage_Test examples/php/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/php/app1/test-report.xml
  Assert_File_Exists $(Files_Path_Root)/examples/php/app1/lint-report.txt

  #Clean
  rm $(Files_Path_Root)/examples/php/app1/test-report.xml
  rm $(Files_Path_Root)/examples/php/app1/lint-report.txt
}
