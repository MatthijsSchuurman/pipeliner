#!/bin/bash

ORIGINALPWD=$PWD #store as soon as script get loaded

if [[ "$OSTYPE" == "darwin"* ]]; then
  if [ ! "$(which grealpath)" ]; then
    echo "grealpath not available, please install coreutils:" >&2
    echo "$ brew install coreutils" >&2
    exit 1
  fi

  realpath() {
    grealpath $@
  }
fi


Files_Path_Original() {
  realpath --relative-to "$(pwd)" "$ORIGINALPWD"
}

Files_Path_Root() {
  realpath --relative-to "$(pwd)" "$(Files_Path_Original)/$(dirname ${BASH_SOURCE[0]})/../.."
}

Files_Path_Work() {
  realpath --relative-to "$(Files_Path_Root)" "$(pwd)"
}

Files_Path_Pipeliner() {
  echo "$(Files_Path_Root)/.pipeliner"
}

Files_Path_Data() {
  local path="$(Files_Path_Pipeliner)/data"

  if [ ! -d "$path" ]; then
    mkdir -p "$path"
  fi

  echo "$path"
}

Files_Get_Class_Files() {
  files=$(find $(Files_Path_Root) -name "*.class.sh" | sort)

  echo $files
}

Files_Pre_Import_Classes() {
  files=$(Files_Get_Class_Files)
  for file in $files; do
    functions=$(grep "^ *[A-Za-z0-9_]\+ *( *) *{*" $file | sed -E "s/ *\( *\) *\{.*//")
    for function in $functions; do
      if type -t $function > /dev/null 2>&1; then #function/command already defined
        continue
      fi

      eval "$function() { source $file; $function \"\$@\"; }"
    done
  done
}

Files_Import_Classes() {
  files=$(Files_Get_Class_Files)
  for file in $files; do
    source $file
  done
}

Files_Get_Stage_Files() {
  files=$(find $(Files_Path_Root) -name "*.stage.sh" | sort)

  echo $files
}

Files_Import_Stages() {
  files=$(Files_Get_Stage_Files)
  for file in $files; do
    source $file
  done
}

Files_Get_Test_Files() {
  files=$(find $(Files_Path_Root) -path "*/test/*.sh" | sort)

  echo $files
}

Files_Import_Tests() {
  files=$(Files_Get_Test_Files)
  for file in $files; do
    source $file
  done
}

Files_Get_Unit_Tests() {
  local file=$1

  unittests=$(grep "^UnitTest_" $file | sed -E "s/\( *\) *\{//")

  echo $unittests
}
Files_Get_Integration_Tests() {
  local file=$1

  integrationtests=$(grep "^IntegrationTest_" $file | sed -E "s/\( *\) *\{//")

  echo $integrationtests
}
Files_Get_E2E_Tests() {
  local file=$1

  e2etests=$(grep "^E2ETest_" $file | sed -E "s/\( *\) *\{//")

  echo $e2etests
}

Files_Watch_Directory_Written() {
  local directory=$1

  which inotifywait > /dev/null 2>&1
  if [ $? == 0 ]; then
    inotifywait --recursive --event close_write --format "%w%f" $directory 2>/dev/null
  else
    which fswatch > /dev/null 2>&1
    if [ $? == 0 ]; then
      local file=$(fswatch -1 --recursive --event Created --event Updated $directory)
      realpath --relative-to "$(pwd)" "$file"
    else
      echo "inotifywait or fswatch not available, please install inotify-tools or fswatch" >&2
      exit 1
    fi
  fi
}


Files_Temp__Dir() {
  local directory=/tmp/pipeliner

  if [ ! -d "$directory" ]; then
    mkdir -p "$directory"
  fi

  echo $directory
}

Files_Temp_File() {
  local prefix=$1
  local suffix=$2

  local filename=$(mktemp -p "$(Files_Temp__Dir)")

  if [ "$prefix" -o "$suffix" ]; then
    local newfilename=$(Files_Temp__Dir)/$prefix$(basename $filename)$suffix
    mv $filename $newfilename
    filename=$newfilename
  fi

  echo $filename
}

Files_Temp_Directory() {
  local prefix=$1
  local suffix=$2

  local filename=$(mktemp -d -p "$(Files_Temp__Dir)")

  if [ "$prefix" -o "$suffix" ]; then
    local newfilename=$(Files_Temp__Dir)/$prefix$(basename $filename)$suffix
    mv $filename $newfilename
    filename=$newfilename
  fi

  echo $filename
}

Files_Temp_Clean() {
  rm -Rf "$(Files_Temp__Dir)" 2> /dev/null
}