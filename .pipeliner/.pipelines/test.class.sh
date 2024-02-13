#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/variables.class.sh
source $(Files_Path_Pipeliner)/core/artifacts.class.sh
source $(Files_Path_Pipeliner)/core/utils/test.class.sh

Pipeliner_Test_Report_Filename() {
  local type=$1
  local version=$(Version_Pipeliner_Full)

  echo ${type}_test_report-$version.txt
}

Pipeliner_Test_Run() {
  local type=$1
  local include=
  local exclude=

  local filename=$(Pipeliner_Test_Report_Filename $type)
  local exitCode=

  if [ $type == "e2e" ]; then
    exclude="ci.local.sh" #prevent infinite loop
  fi

  Log_Info "Running tests"
  Test_Run "$type" "$include" "$exclude" | tee "$(Files_Path_Root)/$filename"
  exitCode=${PIPESTATUS[0]}

  Artifacts_Move "$(Files_Path_Root)/$filename" "testReports/$filename"

  Variables_Set ${type}TestReport "$(Artifacts_Directory)/testReports/$filename" #bit of an assumption here
  return $exitCode
}