#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/test.class.sh

IntegrationTest_Pipeliner_Test_Report_Filename() {
  #Given
  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  #When
  local actual=$(Pipeliner_Test_Report_Filename)

  #Then
  Assert_Match "$actual" "test_report-1.2.345-test.txt"
}

IntegrationTest_Pipeliner_Test_Run() {
  #Given
  local actual=
  local exitCode=

  Test_Run() { #mock
    echo "Fake test report"
    echo
  }

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  #When
  Pipeliner_Test_Run > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"

  Assert_Match "$(Variables_Get testReport)" "$(Files_Path_Root)/test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/test_report-1.2.345-test.txt
}

IntegrationTest_Pipeliner_Test_Run_Fail() {
  #Given
  local actual=
  local exitCode=

  Test_Run() {
    echo "Fake test report"
    echo
    return 1
  }

  Version_Pipeliner_Full() {
    echo "1.2.345-test"
  }

  #When
  Pipeliner_Test_Run > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"

  Assert_Match "$(Variables_Get testReport)" "$(Files_Path_Root)/test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/test_report-1.2.345-test.txt
}