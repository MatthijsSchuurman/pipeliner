#!/bin/bash

Environment_Platform() {
  if [ -f /.dockerenv ]; then
    echo "docker"
  elif [ "$AGENT_ID" ]; then
    echo "azure"
  elif [ "$GITHUB_ACTIONS" ]; then
    echo "github"
  elif [ "$GITLAB_CI" ]; then
    echo "gitlab"
  elif [ "$BITBUCKET_BUILD_NUMBER" ]; then
    echo "bitbucket"
  else
    echo "local"
  fi
}

Environment_OS() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "windows"
  elif [[ "$OSTYPE" == "msys" ]]; then
    echo "windows"
  elif [[ "$OSTYPE" == "win32" ]]; then
    echo "windows"
  elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "bsd"
  else
    echo "Unknown OS" >&2
    exit 1
  fi
}

Environment_Distro() {
  if [ -f /etc/os-release ]; then
    echo $(cat /etc/os-release | grep -oP '(?<=^ID=).+' | tr -d '"')
  fi
}

Environment_Architecture() {
  echo $(uname -m)
}

Environment_Package_Manager() {
  which apt-get > /dev/null 2>&1
  if [ $? == 0 ]; then
    echo "apt"
    return
  fi

  which yum > /dev/null 2>&1
  if [ $? == 0 ]; then
    echo "yum"
    return
  fi

  which pacman > /dev/null 2>&1
  if [ $? == 0 ]; then
    echo "pacman"
    return
  fi

  which brew > /dev/null 2>&1
  if [ $? == 0 ]; then
    echo "brew"
    return
  fi

  echo "unknown"
}