#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh
source $(Files_Path_Pipeliner)/core/utils/test.class.sh

Pipeliner_Test_Report_Filename() {
  local type=$1
  local version=$(Version_Pipeliner_Full)

  echo ${type}_test_report-$version.txt
}

Pipeliner_Test_Run() {
  local type=$1
  local filename=$(Pipeliner_Test_Report_Filename $type)
  local exitCode=

  Log_Info "Running tests"
  Test_Run $type | tee "$(Files_Path_Root)/$filename"
  exitCode=${PIPESTATUS[0]}

  Variables_Set ${type}TestReport "$(Files_Path_Root)/$filename"
  return $exitCode
}