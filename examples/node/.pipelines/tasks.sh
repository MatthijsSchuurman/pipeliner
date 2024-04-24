#!/bin/bash

Node_Pipelines_Affected() {
 local mode=$1

  case $mode in
    "#all")
      apps=$(ls -d $(Files_Path_Root)/examples/node/*)
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
    if [ ! -f $(Files_Path_Root)/$app/package.json ]; then
      continue
    fi

    echo "$app"
  done
}


Node_Pipelines_Build() {
  local app=$1

  Node_NPM_Install $app prod

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}


Node_Pipelines_Test() {
  local app=$1

  Node_NPM_Test $app
  Node_NPM_Lint $app
}