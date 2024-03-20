#!/bin/bash

IntegrationTest_Examples_Haskell_Pipelines_Stage_Test() {
  #Given
  source $(Files_Path_Pipeliner)/init.sh

  #When
  Haskell_Pipelines_Stage_Test examples/haskell/app1

  #Then
  Assert_File_Exists $(Files_Path_Root)/examples/haskell/app1/test-report.txt
  #Assert_File_Exists $(Files_Path_Root)/examples/haskell/app1/lint-report.html

  #Clean
  rm $(Files_Path_Root)/examples/haskell/app1/test-report.txt
  #rm $(Files_Path_Root)/examples/haskell/app1/lint-report.html
}
