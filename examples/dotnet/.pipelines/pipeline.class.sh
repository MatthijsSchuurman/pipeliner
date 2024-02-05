#!/bin/bash

DotNet_Pipelines_Affected() {
 local mode=$1

  case $mode in
    "#all")
      apps=$(ls -d $(Files_Path_Root)/examples/dotnet/*)
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
    if [ ! -f $(Files_Path_Root)/$app/*.sln ]; then
      continue
    fi

    echo "$app"
  done
}
