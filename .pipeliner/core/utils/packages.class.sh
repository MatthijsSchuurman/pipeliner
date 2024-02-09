#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh

Packages_Installed() {
  local bin=$1

  which $bin > /dev/null 2>&1
}

Packages_Version() {
  local bin=$1

  case $bin in
    "ssh" | "scp" | "ssh-keygen")
      $bin -V 2>&1
      ;;
    "zip" | "unzip")
      $bin -v | head -n 1
      ;;
    "wget")
      $bin --version | head -n 1
      ;;
    *)
      $bin --version
      ;;
  esac
}

Packages__Determine_Manager() {
  local manager=

  if Packages_Installed apt; then
    manager=apt
  elif Packages_Installed apt-get; then
    manager=apt
  elif Packages_Installed pacman; then
    manager=pacman
  elif Packages_Installed yum; then
    manager=yum
  elif Packages_Installed brew; then
    manager=brew
  elif Packages_Installed apk; then
    manager=apk
  else
    manager=unknown
  fi

  echo "$manager"
}

Packages__Determine_Packages() {
  local bin=$1
  local packages=

  case $bin in
    "ssh" | "scp" | "ssh-keygen")
      packages=openssh
      ;;
    "zip" | "unzip")
      packages="zip unzip"
      ;;
    "docker")
      if [ $(Packages__Determine_Manager) == "apt" ]; then
        packages=docker.io
      else
        packages=docker
      fi
      ;;
    *)
      packages=$bin
      ;;
  esac

  echo "$packages"
}

Packages__Determine_Services() {
  local bin=$1
  local services=

  case $bin in
    "docker")
      services="$bin.service $bin.socket"
      ;;
    *)
      services=$bin.service
      ;;
  esac

  echo "$services"
}

Packages_Update() {
  local manager=$(Packages__Determine_Manager)

  local exitCode=
  Log_Group "Updating package list"
  case $manager in
    "apt")
      sudo apt update
      exitCode=$?
      ;;
    "pacman")
      sudo pacman -Sy
      exitCode=$?
      ;;
    "yum")
      sudo yum update
      exitCode=$?
      ;;
    "apk")
      sudo apk update
      exitCode=$?
      ;;
    *)
      Log_Error "Package manager not supported: $manager"
      return 1
      ;;
  esac

  if [ $exitCode != 0 ]; then
    Log_Error "Failed to update package list"
  fi

  Log_Group_End

  return $exitCode
}

Packages_Install() {
  local bin=$1

  if [ $(Environment_Platform) == "docker" ]; then
    Log_Error "Use Dockerfile to install packages"
    return 1
  fi

  local packages=$(Packages__Determine_Packages $bin)
  local manager=$(Packages__Determine_Manager)

  local exitCode=
  Log_Group "Installing package: $packages"
  case $manager in
    "apt")
      sudo apt install -y $packages
      exitCode=$?
      ;;
    "pacman")
      sudo pacman -S --noconfirm $packages
      exitCode=$?
      ;;
    "yum")
      sudo yum install -y $packages
      exitCode=$?
      ;;
    "brew")
      brew install $packages
      exitCode=$?
      ;;
    "apk")
      sudo apk add $packages
      exitCode=$?
      ;;
    *)
      Log_Error "Package manager not supported: $manager"
      return 1
      ;;
  esac

  if [ $exitCode != 0 ]; then
    Log_Error "Failed to install package: $packages"
  fi

  Log_Group_End

  return $exitCode
}

Packages_Start_Service() {
  local bin=$1
  local services=$(Packages__Determine_Services $bin)

  local exitCode=
  Log_Group "Starting service: $services"
  for service in $services; do
    sudo systemctl enable $service
    if [ $? != 0 ]; then
      Log_Error "Failed to enable service: $service"
      exitCode=1
    fi

    sudo systemctl start $service
    if [ $? != 0 ]; then
      Log_Error "Failed to start service: $service"
      exitCode=1
    fi
  done
  Log_Group_End

  return $exitCode
}

Packages_Prerequisites() {
  local bins=$@
  local updated=false

  for bin in $bins; do
    if ! Packages_Installed $bin; then
      if [ $updated == false ]; then
        Packages_Update
        updated=true
      fi

      Packages_Install $bin

      case $bin in
        "docker" | "ssh")
          Packages_Start_Service $bin
          ;;
      esac
    fi

    Log_Debug "$(Packages_Version $bin)"
  done
}