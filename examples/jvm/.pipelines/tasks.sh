#!/bin/bash

JVM_Pipelines_Affected() {
 local mode=$1

  case $mode in
    "#all")
      apps=$(ls -d $(Files_Path_Root)/examples/jvm/*)
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
    if [ ! -f $(Files_Path_Root)/$app/build.gradle* ]; then
      continue
    fi

    echo "$app"
  done
}


JVM_Pipelines_Build() {
  local app=$1

  JVM_Gradle_Clean $app
  JVM_Gradle_Build $app

  local curpath=$(pwd)
  cd "$(Files_Path_Root)/$app"
  Docker_Build Dockerfile "$app:latest"
  local exitCode=$?
  cd "$curpath"

  return $exitCode
}


JVM_Pipelines_Test() {
  local app=$1

  JVM_Gradle_Test $app
}