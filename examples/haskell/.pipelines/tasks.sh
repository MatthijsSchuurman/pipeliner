#!/bin/bash

Haskell_Pipelines_Affected() {
 local mode=$1

  case $mode in
    "#all")
      apps=$(ls -d $(Files_Path_Root)/examples/haskell/*)
      apps=${apps//$(Files_Path_Root)\//}
      ;;
    "#affected" | "")
      apps=$(VCS_Affected_Directories "" 3)
      ;;
    *)
      apps=$mode
      ;;
  esac

  for app in $apps; do
    if [ ! -f $(Files_Path_Root)/$app/*.cabal ]; then
      continue
    fi

    echo "$app"
  done
}


Haskell_Pipelines_Build() {
  local app=$1

  Haskell_Cabal_Build $app

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}


Haskell_Pipelines_Test() {
  local app=$1

  Haskell_Cabal_Test $app
  #Haskell_Cabal_Lint $app
}