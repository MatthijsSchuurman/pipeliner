#!/bin/bash

source $(Files_Path_Pipeliner)/.pipelines/test.sh

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
    local types=$1
    local include=$2
    local exclude=$3
    echo "Fake test report"
    echo "type: $types"
    echo "include: $include"
    echo "exclude: $exclude"
    echo
  }

  Version_Pipeliner_Full() { #mock
    echo "1.2.345-test"
  }
  Artifacts_Directory() { #mock
    echo "artifacts-test"
  }

  rm -rf "$(Artifacts_Directory)"
  mkdir -p "$(Artifacts_Directory)"

  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Test_Run unit > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Fake test report"
  Assert_Contains "$actual" "type: unit"
  Assert_Contains "$actual" "include: "
  Assert_Contains "$actual" "exclude: "

  Assert_Equal "$(Variables_Get unitTestReport)" "$(Artifacts_Directory)/testReports/unit_test_report-1.2.345-test.txt"
  Assert_File_Exists "$(Artifacts_Directory)/testReports/unit_test_report-1.2.345-test.txt"
  local report=$(cat $(Artifacts_Directory)/testReports/unit_test_report-1.2.345-test.txt)
  Assert_Contains "$report" "Fake test report"

  #Clean
  rm -rf "$(Artifacts_Directory)"


  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Test_Run integration > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Fake test report"
  Assert_Contains "$actual" "type: integration"
  Assert_Contains "$actual" "include: "
  Assert_Contains "$actual" "exclude: "

  Assert_Equal "$(Variables_Get integrationTestReport)" "$(Artifacts_Directory)/testReports/integration_test_report-1.2.345-test.txt"
  Assert_File_Exists "$(Artifacts_Directory)/testReports/integration_test_report-1.2.345-test.txt"
  local report=$(cat $(Artifacts_Directory)/testReports/integration_test_report-1.2.345-test.txt)
  Assert_Contains "$report" "Fake test report"

  #Clean
  rm -rf "$(Artifacts_Directory)"


  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Test_Run e2e > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Running tests"
  Assert_Contains "$actual" "Fake test report"
  Assert_Contains "$actual" "type: e2e"
  Assert_Contains "$actual" "include: "
  Assert_Contains "$actual" "exclude: cd.local"

  Assert_Equal "$(Variables_Get e2eTestReport)" "$(Artifacts_Directory)/testReports/e2e_test_report-1.2.345-test.txt"
  Assert_File_Exists "$(Artifacts_Directory)/testReports/e2e_test_report-1.2.345-test.txt"
  local report=$(cat $(Artifacts_Directory)/testReports/e2e_test_report-1.2.345-test.txt)
  Assert_Contains "$report" "Fake test report"

  #Clean
  rm -rf "$(Artifacts_Directory)"
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
  Artifacts_Directory() { #mock
    echo "artifacts-test"
  }

  rm -rf "$(Artifacts_Directory)"
  mkdir -p "$(Artifacts_Directory)"

  #When
  local logFile=$(Files_Temp_File test .log)
  Pipeliner_Test_Run fail > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 1
  Assert_Match "$actual" "Running tests"
  Assert_Match "$actual" "Fake test report"

  Assert_Equal "$(Variables_Get failTestReport)" "$(Artifacts_Directory)/testReports/fail_test_report-1.2.345-test.txt"
  Assert_File_Exists "$(Artifacts_Directory)/testReports/fail_test_report-1.2.345-test.txt"

  #Clean
  rm -rf "$(Artifacts_Directory)"
}