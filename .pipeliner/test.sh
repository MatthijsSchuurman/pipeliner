#!/bin/bash

source $(dirname "${BASH_SOURCE[0]}")/core/files.class.sh
source $(Files_Path_Pipeliner)/core/test.class.sh
source $(Files_Path_Pipeliner)/core/assert.class.sh
source $(Files_Path_Pipeliner)/core/colors.class.sh
source $(Files_Path_Pipeliner)/core/cli.class.sh
source $(Files_Path_Pipeliner)/core/version.class.sh

Test_SH_Watch() {
  echo -n "Watching for changes in "
  Color_Yellow $(Files_Path_Root) ; echo
  echo

  while true; do
    file=$(Files_Watch_Directory_Written "$(Files_Path_Root)")
    if [ $? != 0 ]; then break; fi #exit on error
    if [[ "$file" != *".sh" ]]; then continue; fi #skip non-sh files

    echo -n "Re-running tests for "
    Color_Yellow $file ; echo
    echo

    if [[ "$file" != *"/test/"*".sh" ]]; then #class/stage/normal scripts
      file=$(dirname $file)/test/$(basename $file) #assume related test file is in test directory
    fi

    Test_Run "" $file ""
    echo
  done
}


#Main logic
echo

argumentsDefinition="
--watch: watch #Watch for changes and re-run tests
--type: type #Test type (unit,integration,e2e)
--include: include #Include pattern
--exclude: exclude #Exclude pattern

--help: help #Show usage information
--stats: stats #Show statistics
--version: version #Show version information

-w: watch #--watch
-t: type #--type
-i: include #--include
-e: exclude #--exclude
"

arguments=$(CLI_Arguments "$argumentsDefinition" "$@")

if Dictionary_Exists "$arguments" FAILURES ; then
  echo
  CLI_Arguments_Usage ${BASH_SOURCE[0]} "$argumentsDefinition"
  echo
  exit 1
elif Dictionary_Exists "$arguments" help,0 ; then
  CLI_Arguments_Usage ${BASH_SOURCE[0]} "$argumentsDefinition"
elif Dictionary_Exists "$arguments" version,0 ; then
  echo "Pipeliner $(Version_Pipeliner)"
elif Dictionary_Exists "$arguments" stats,0 ; then
  echo "Test statistics"
  echo
  Test_Statistics
elif Dictionary_Exists "$arguments" watch,0 ; then
  Test_SH_Watch
else #run once
  Test_Run "$(Dictionary_Get "$arguments" type,0 2> /dev/null)" "$(Dictionary_Get "$arguments" include,0 2> /dev/null)" "$(Dictionary_Get "$arguments" exclude,0 2> /dev/null)"
fi

echo