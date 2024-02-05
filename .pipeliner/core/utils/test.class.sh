#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/dictionary.class.sh
source $(Files_Path_Pipeliner)/core/utils/colors.class.sh
source $(Files_Path_Pipeliner)/core/utils/files.class.sh

Test_Run() {
  local types=$1
  local include=$2
  local exclude=$3

  if [ ! $types ]; then
    types="unit,integration,e2e"
  fi

  local statsPassed=0
  local statsFailed=0
  local statsSkipped=0
  local statsTotal=0


  for file in $(Files_Get_Test_Files); do
    if [ $include ] && [[ $file != *$include* ]]; then
      continue
    fi
    if [ $exclude ] && [[ $file == *$exclude* ]]; then
      continue
    fi

    Color_White "$(Test__Title $file)"
    echo
    source $file # Import tests

    for test in $(Files_Get_Unit_Tests $file); do
      echo -n "- $(Test__Name $test): "

      if [[ $types != *"unit"* ]]; then
        Color_Blue "SKIP" ; echo
        statsSkipped=$((statsSkipped+1))
      else
        Test_Execute $test

        case $? in
          0)
            statsPassed=$((statsPassed+1))
            ;;
          255)
            statsSkipped=$((statsSkipped+1))
            ;;
          *)
            statsFailed=$((statsFailed+1))
            ;;
        esac
      fi

      statsTotal=$((statsTotal+1))
    done

    for test in $(Files_Get_Integration_Tests $file); do
      echo -n "- $(Color_Grey "$(Test__Name $test)"): "

      if [[ $types != *"integration"* ]]; then
        Color_Blue "SKIP" ; echo
        statsSkipped=$((statsSkipped+1))
      else
        Test_Execute $test

        case $? in
          0)
            statsPassed=$((statsPassed+1))
            ;;
          255)
            statsSkipped=$((statsSkipped+1))
            ;;
          *)
            statsFailed=$((statsFailed+1))
            ;;
        esac
      fi

      statsTotal=$((statsTotal+1))
    done

    for test in $(Files_Get_E2E_Tests $file); do
      echo -n "- $(Color_Gray "$(Test__Name $test)"): "

      if [[ $types != *"e2e"* ]]; then
        Color_Blue "SKIP" ; echo
        statsSkipped=$((statsSkipped+1))
      else
        Test_Execute $test

        case $? in
          0)
            statsPassed=$((statsPassed+1))
            ;;
          255)
            statsSkipped=$((statsSkipped+1))
            ;;
          *)
            statsFailed=$((statsFailed+1))
            ;;
        esac
      fi

      statsTotal=$((statsTotal+1))
    done

    echo
  done

  echo -n "$(Color_Green ${statsPassed}) passed / "
  if [ ${statsFailed} != 0 ]; then
    echo -n "$(Color_Red ${statsFailed}) failed / "
  fi
  if [ ${statsSkipped} != 0 ]; then
    echo -n "$(Color_Blue ${statsSkipped}) skipped / "
  fi
  echo "${statsTotal} total"

  if [ ${statsFailed} != 0 ]; then
    return 1
  fi
}

Test_Statistics() {
  local subtotalsUnit=0
  local subtotalsIntegration=0
  local subtotalsE2E=0
  local subtotalsTotal=0

  local totalsUnit=0
  local totalsIntegration=0
  local totalsE2E=0
  local totalsTotal=0

  local currentDirectory=
  for file in $(Files_Get_Test_Files); do
    local directory=$(dirname $file | cut -d'/' -f1-2)
    if [ "$directory" != "$currentDirectory" ]; then

      if [ "$currentDirectory" != "" ]; then
        Color_Yellow $currentDirectory
        echo
        echo "Unit tests: ${subtotalsUnit}"
        echo "Integration tests: $(Color_Grey ${subtotalsIntegration})"
        echo "E2E tests: $(Color_Gray ${subtotalsE2E})"
        echo
      fi

      subtotalsUnit=0
      subtotalsIntegration=0
      subtotalsE2E=0
      subtotalsTotal=0
      currentDirectory=$directory
    fi

    local unit=$(Files_Get_Unit_Tests "$file" | wc -w)
    if [ $unit -gt 0 ]; then
      subtotalsUnit=$((subtotalsUnit + $unit))
      totalsUnit=$((totalsUnit + $unit))
    fi

    local integration=$(Files_Get_Integration_Tests "$file" | wc -w)
    if [ $integration -gt 0 ]; then
      subtotalsIntegration=$((subtotalsIntegration + $integration))
      totalsIntegration=$((totalsIntegration + $integration))
    fi

    local e2e=$(Files_Get_E2E_Tests "$file" | wc -w)
    if [ $e2e -gt 0 ]; then
      subtotalsE2E=$((subtotalsE2E + $e2e))
      totalsE2E=$((totalsE2E + $e2e))
    fi
  done

  if [ "$currentDirectory" != "" ]; then
    Color_Yellow $currentDirectory
    echo
    echo "Unit tests: ${subtotalsUnit}"
    echo "Integration tests: $(Color_Grey ${subtotalsIntegration})"
    echo "E2E tests: $(Color_Gray ${subtotalsE2E})"
    echo
  fi

  totals[total]=$((totalsUnit + totalsIntegration + totalsE2E))
  Color_Yellow "Total"
  echo
  echo "Unit tests: ${totalsUnit}"
  echo "Integration tests: $(Color_Grey ${totalsIntegration})"
  echo "E2E tests: $(Color_Gray ${totalsE2E})"
  echo "Total tests: $(Color_White ${totals[total]})"
}

Test__Title() {
  local file=$1

  local title="${file//"$(Files_Path_Root)"\//}"
  title=${title//.pipeliner/pipeliner}
  title=$(echo $title | sed -E "s/\.(class|stage|local|test)\.sh//" | sed -E "s/(test)?\// /g")
  title=$(echo $title | tr '[:lower:]' '[:upper:]' <<< ${title:0:1})${title:1}

  echo $title
}

Test__Name() {
  local test=$1
  local name=$(echo "$test"| sed -E "s/^UnitTest_//" | sed -E "s/^IntegrationTest_//" | sed -E "s/^E2ETest_//" | sed -E "s/_+/ /g")
  echo $name
}

Test_Execute() {
  local test=$1
  local log=
  local exitCode=

  log=$($test)
  exitCode=$?
  case $exitCode in
    0)
      Color_Green "OK" ; echo
      ;;
    255)
      Color_Blue "SKIP" ; echo
      ;;
    *)
      Color_Red "FAIL" ; echo
      if [ "$log" ]; then
        echo "$log"
        echo
      fi
      ;;
  esac

  return $exitCode
}