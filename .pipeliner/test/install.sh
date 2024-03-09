#!/bin/bash

UnitTest_Install_Test_mode(){
  #Given
  local actual=
  local exitCode=

  #When
  actual=$(source $(Files_Path_Pipeliner)/install.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Test mode"
}

UnitTest_Install_Directory(){
  #Given
  local actual=

  #When
  source $(Files_Path_Pipeliner)/install.sh
  actual=$(Install_Directory)

  #Then
  Assert_Equal "$actual" "$(pwd)"


  #Given
  cd /tmp

  #When
  source $(Files_Path_Pipeliner)/install.sh
  actual=$(Install_Directory)

  #Then
  Assert_Equal "$actual" "/tmp"
}

UnitTest_Install_Directory_Temp(){
  #Given
  local actual=

  #When
  source $(Files_Path_Pipeliner)/install.sh
  actual=$(Install_Directory_Temp)

  #Then
  Assert_Equal "$actual" "$(pwd)/.tmp"


  #Given
  cd /tmp

  #When
  source $(Files_Path_Pipeliner)/install.sh
  actual=$(Install_Directory_Temp)

  #Then
  Assert_Equal "$actual" "/tmp/.tmp"
}

UnitTest_Install_Directory_Temp_Flush(){
  #Given
  source $(Files_Path_Pipeliner)/install.sh
  local tmp=$(Install_Directory_Temp)

  #When
  Install_Directory_Temp_Flush

  #Then
  Assert_Directory_Exists "$tmp"
  Assert_Not_File_Exists "$tmp/file1"


  #Given
  touch "$tmp/file1"

  #When
  Install_Directory_Temp_Flush

  #Then
  Assert_Directory_Exists "$tmp"
  Assert_Not_File_Exists "$tmp/file1"

  #Cleanup
  rm -Rf "$tmp"
}

UnitTest_Install_Directory_Temp_Clear(){
  #Given
  source $(Files_Path_Pipeliner)/install.sh
  local tmp=$(Install_Directory_Temp)

  #When
  Install_Directory_Temp_Clear

  #Then
  Assert_Not_Directory_Exists "$tmp"


  #Given
  mkdir -p "$tmp"
  touch "$tmp/file1"

  #When
  Install_Directory_Temp_Clear

  #Then
  Assert_Not_Directory_Exists "$tmp"
}

UnitTest_Install_Is_Upgrade() {
  #Given
  local exitCode=

  #When
  source $(Files_Path_Pipeliner)/install.sh
  Install_Is_Upgrade
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0


  #Given
  cd /tmp

  #When
  source $(Files_Path_Pipeliner)/install.sh
  Install_Is_Upgrade
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
}

UnitTest_Install_Download() {
  #Given
  local actual=
  local exitCode=

  cd /tmp
  rm -Rf pipeliner*.zip
  source $(Files_Path_Pipeliner)/install.sh

  #When
  actual=$(Install_Download "$PACKAGEURL")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "^pipeliner.*\.zip$"
  Assert_File_Exists "$actual"

  #Cleanup
  rm -Rf "$actual"
}

UnitTest_Install_Extract() {
  #Given
  local package=
  local exitCode=
  local directory=tmp
  local currentDirectory=$(pwd)

  rm -Rf "$directory"
  mkdir -p "$directory"
  cd "$directory"

  source $(Files_Path_Pipeliner)/install.sh
  Install_Directory_Temp_Flush #ensure tmp folder is created
  package=$(Install_Download "$PACKAGEURL")

  #When
  Install_Extract $package
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists "$(Install_Directory_Temp)/.pipeliner"
  Assert_File_Exists "$(Install_Directory_Temp)/.pipeliner/init.sh"
  Assert_Directory_Exists "$(Install_Directory_Temp)/.vscode"
  Assert_File_Exists "$(Install_Directory_Temp)/.vscode/extensions.json"
  Assert_Directory_Exists "$(Install_Directory_Temp)/.azuredevops"
  Assert_File_Exists "$(Install_Directory_Temp)/.azuredevops/ci.yml"
  Assert_Directory_Exists "$(Install_Directory_Temp)/.github"
  Assert_File_Exists "$(Install_Directory_Temp)/.github/workflows/ci.yml"
  Assert_Directory_Exists "$(Install_Directory_Temp)/examples"
  Assert_File_Exists "$(Install_Directory_Temp)/examples/node/app1/Dockerfile"
  Assert_File_Exists "$(Install_Directory_Temp)/Vagrantfile"

  #Cleanup
  cd "$currentDirectory"
  rm -Rf "$directory"
}

UnitTest_Install_Install() {
  #Given
  local exitCode=
  local directory=tmp
  local currentDirectory=$(pwd)

  rm -Rf "$directory"
  mkdir -p "$directory"
  cd "$directory"

  source $(Files_Path_Pipeliner)/install.sh
  mkdir -p "$(Install_Directory_Temp)/.pipeliner" "$(Install_Directory_Temp)/.azuredevops" "$(Install_Directory_Temp)/.github/workflows" "$(Install_Directory_Temp)/.vscode" "$(Install_Directory_Temp)/examples/node/app1"
  touch "$(Install_Directory_Temp)/.pipeliner/init.sh" "$(Install_Directory_Temp)/.azuredevops/ci.yml" "$(Install_Directory_Temp)/.github/workflows/ci.yml" "$(Install_Directory_Temp)/Vagrantfile" "$(Install_Directory_Temp)/.vscode/extensions.json" "$(Install_Directory_Temp)/examples/node/app1/Dockerfile"

  #When
  Install_Install
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists "$(Install_Directory)/.pipeliner"
  Assert_File_Exists "$(Install_Directory)/.pipeliner/init.sh"
  Assert_Directory_Exists "$(Install_Directory)/.azuredevops"
  Assert_File_Exists "$(Install_Directory)/.azuredevops/ci.yml"
  Assert_Directory_Exists "$(Install_Directory)/.github"
  Assert_File_Exists "$(Install_Directory)/.github/workflows/ci.yml"
  Assert_File_Exists "$(Install_Directory)/Vagrantfile"
  Assert_Directory_Exists "$(Install_Directory)/.vscode"
  Assert_File_Exists "$(Install_Directory)/.vscode/extensions.json"
  Assert_Directory_Exists "$(Install_Directory)/examples"
  Assert_File_Exists "$(Install_Directory)/examples/node/app1/Dockerfile"

  #Cleanup
  cd "$currentDirectory"
  rm -Rf "$directory"
}

UnitTest_Install_Install_vscode() {
  #Given
  local exitCode=
  local directory=tmp
  local currentDirectory=$(pwd)

  rm -Rf "$directory"
  mkdir -p "$directory"
  mkdir -p "$directory/.vscode"
  touch "$directory/.vscode/settings.json"
  cd "$directory"

  source $(Files_Path_Pipeliner)/install.sh
  mkdir -p "$(Install_Directory_Temp)/.pipeliner" "$(Install_Directory_Temp)/.azuredevops" "$(Install_Directory_Temp)/.github/workflows" "$(Install_Directory_Temp)/.vscode" "$(Install_Directory_Temp)/examples/node/app1"
  touch "$(Install_Directory_Temp)/.pipeliner/init.sh" "$(Install_Directory_Temp)/.azuredevops/ci.yml" "$(Install_Directory_Temp)/.github/workflows/ci.yml" "$(Install_Directory_Temp)/Vagrantfile" "$(Install_Directory_Temp)/.vscode/extensions.json" "$(Install_Directory_Temp)/examples/node/app1/Dockerfile"
  echo test > "$(Install_Directory_Temp)/.vscode/settings.json" #shouldn't overwrite existing settings.json

  #When
  Install_Install
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists "$(Install_Directory)/.pipeliner"
  Assert_File_Exists "$(Install_Directory)/.pipeliner/init.sh"
  Assert_Directory_Exists "$(Install_Directory)/.azuredevops"
  Assert_File_Exists "$(Install_Directory)/.azuredevops/ci.yml"
  Assert_Directory_Exists "$(Install_Directory)/.github"
  Assert_File_Exists "$(Install_Directory)/.github/workflows/ci.yml"
  Assert_File_Exists "$(Install_Directory)/Vagrantfile"
  Assert_Directory_Exists "$(Install_Directory)/.vscode"
  Assert_File_Exists "$(Install_Directory)/.vscode/extensions.json"
  Assert_File_Exists "$(Install_Directory)/.vscode/settings.json"

  local size=$(stat -c%s "$(Install_Directory)/.vscode/settings.json" 2>/dev/null || stat -f%z "$(Install_Directory)/.vscode/settings.json" 2>/dev/null)
  Assert_Equal $size 0

  Assert_Directory_Exists "$(Install_Directory)/examples"
  Assert_File_Exists "$(Install_Directory)/examples/node/app1/Dockerfile"

  #Cleanup
  cd "$currentDirectory"
  rm -Rf "$directory"
}

UnitTest_Install_Validate() {
  #Given
  local actual=
  local exitCode=

  source $(Files_Path_Pipeliner)/install.sh

  #When
  actual=$(Install_Validate)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Installed Pipeliner" OK
  Assert_Contains "$actual" "Installed GitHub" OK
  Assert_Contains "$actual" "Installed Examples" OK
  Assert_Contains "$actual" "Installed Vagrant" OK
  Assert_Contains "$actual" "Installed VSCode" OK
  Assert_Contains "$actual" "Installed AzureDevOps" OK
  Assert_Match "$actual" "[0-9]+.* passed / [0-9]+ total"
}

E2ETest_Install() {
  #Given
  local actual=
  local exitCode=
  local directory=tmp
  local currentDirectory=$(pwd)

  mkdir -p "$directory"
  cd "$directory"

  #When
  actual=$($(Files_Path_Pipeliner)/install.sh)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" Downloading Installing Validating
  Assert_Directory_Exists .pipeliner
  Assert_File_Exists .pipeliner/init.sh
  Assert_Directory_Exists .azuredevops
  Assert_File_Exists .azuredevops/ci.yml
  Assert_Directory_Exists .github
  Assert_File_Exists .github/workflows/ci.yml
  Assert_File_Exists Vagrantfile
  Assert_Directory_Exists .vscode
  Assert_File_Exists .vscode/extensions.json
  Assert_Directory_Exists examples
  Assert_File_Exists examples/node/app1/Dockerfile


  #When
  actual=$(cat $(Files_Path_Pipeliner)/install.sh | bash)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" Downloading Upgrading Validating
  Assert_Directory_Exists .pipeliner
  Assert_File_Exists .pipeliner/init.sh
  Assert_Directory_Exists .azuredevops
  Assert_File_Exists .azuredevops/ci.yml
  Assert_Directory_Exists .github
  Assert_File_Exists .github/workflows/ci.yml
  Assert_File_Exists Vagrantfile
  Assert_Directory_Exists .vscode
  Assert_File_Exists .vscode/extensions.json
  Assert_Directory_Exists examples
  Assert_File_Exists examples/node/app1/Dockerfile

  #Cleanup
  cd "$currentDirectory"
  rm -Rf "$directory"
}