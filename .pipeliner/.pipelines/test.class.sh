#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh
source $(Files_Path_Pipeliner)/core/utils/test.class.sh

Pipeliner_Test_Report_Filename() {
  local version=$(Version_Pipeliner_Full)

  echo "test_report-$version.txt"
}

Pipeliner_Test_Run() {
  local filename=$(Pipeliner_Test_Report_Filename)
  local exitCode=

  Log_Info "Running tests"

  Test_Run unit | tee "$(Files_Path_Root)/$filename"
  exitCode=${PIPESTATUS[0]}

  Variables_Set testReport "$(Files_Path_Root)/$filename"
  return $exitCode
}