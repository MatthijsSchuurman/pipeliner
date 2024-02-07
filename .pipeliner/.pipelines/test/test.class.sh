#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/test.class.sh

IntegrationTest_Pipeliner_Test_Report_Filename() {
  #Given
  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }

  #When
  local actual=$(Pipeliner_Test_Report_Filename unit)

  #Then
  Assert_Match "$actual" "unit_test_report-1.2.345-test.txt"


  #When
  local actual=$(Pipeliner_Test_Report_Filename integration)

  #Then
  Assert_Match "$actual" "integration_test_report-1.2.345-test.txt"
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
  Pipeliner_Test_Run unit > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"

  Assert_Equal "$(Variables_Get unitTestReport)" "$(Files_Path_Root)/unit_test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/unit_test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/unit_test_report-1.2.345-test.txt

  #When
  Pipeliner_Test_Run integration > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"


  Assert_Equal "$(Variables_Get integrationTestReport)" "$(Files_Path_Root)/integration_test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/integration_test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/integration_test_report-1.2.345-test.txt
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
  Pipeliner_Test_Run fail > tmp.log
  exitCode=$?
  actual=$(cat tmp.log)
  rm tmp.log

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"

  Assert_Equal "$(Variables_Get failTestReport)" "$(Files_Path_Root)/fail_test_report-1.2.345-test.txt"
  Assert_File_Exists $(Files_Path_Root)/fail_test_report-1.2.345-test.txt

  #Clean
  rm $(Files_Path_Root)/fail_test_report-1.2.345-test.txt
}