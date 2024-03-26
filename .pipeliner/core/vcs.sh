#!/bin/bash

source $(Files_Path_Pipeliner)/core/files.class.sh
source $(Files_Path_Pipeliner)/core/log.class.sh

VCS_Affected() {
  local branch=$1

  if [ -d $(Files_Path_Root)/.hg ]; then
    if [ ! "$branch" ]; then
      branch=$(hg branch)
    fi
    files=$(hg status --rev $branch)
  elif [ -d $(Files_Path_Root)/.git ]; then
    if [ ! "$branch" ]; then
      branch=$(git branch --show-current)
    fi
    files=$(git diff --name-only $branch)
  else
    Log_Error "Unknown version control system" >&2
    exit 1
  fi

  #remove prefix M (modified), A (added), R (removed), ! (missing), ? (not tracked)
  files=$(echo "$files" | sed -E "s/^[MAR!?] //")
  echo "$files" | sort
}

VCS_Affected_Directories() {
  local branch=$1
  local depth=$2

  local files=
  files=$(VCS_Affected $branch)
  if [ $? != 0 ]; then return 1 ; fi

  local directories=()
  for file in $files; do
    if [ -L "$(Files_Path_Root)/$file" ]; then #symlink
      directories+=("$file")
    else
      directories+=("$(dirname $file)")
    fi
  done
  directories=$(IFS=$'\n'; echo "${directories[*]}" | sort | uniq)

  if [ "$depth" ]; then
    directories=$(echo "$directories" | cut -d'/' -f1-$depth)
  fi

  echo "$directories" | uniq
}

VCS_Clone_Directory() {
  local source=$1
  local target=$2
  local exitCode=

  if [ -d "$target" ]; then
    Log_Group "Updating repository $target"
    cd "$target"
    if [ -d .hg ]; then
      hg pull --update --force
      exitCode=$?
    elif [ -d .git ]; then
      git pull --force
      exitCode=$?
    else
      Log_Error "Unknown version control system" >&2
      Log_Group_End
      exit 1
    fi
    cd - > /dev/null
    Log_Group_End
  else
    Log_Group "Cloning repository $source to $target"
    if [ -d "$source/.hg" ]; then
      hg clone "$source" "$target"
      exitCode=$?
    elif [ -d "$source/.git" ]; then
      git clone "$source" "$target" 2> /dev/null
      exitCode=$?
    else
      Log_Error "Unknown version control system" >&2
      Log_Group_End
      exit 1
    fi
    Log_Group_End
  fi

  return $exitCode
}
