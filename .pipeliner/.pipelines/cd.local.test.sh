#!/bin/bash

E2ETest_Pipeliner_Pipeline_CD() {
  if [ ! -d $(Files_Path_Root)/.hg ] && [ ! -d $(Files_Path_Root)/.git ]; then exit 255; fi #skip

  #Given
  local actual=
  local exitCode=

  #When
  actual=$($(Files_Path_Pipeliner)/.pipelines/cd.local.sh 2>&1)
  exitCode=$?

  echo "$actual"

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "Docker version"

  Assert_Contains "$actual" "Creating package"
  Assert_Contains "$actual" "adding: .pipeliner/test"
  Assert_Contains "$actual" "adding: examples/node/app1/test/helloworld.js"
  Assert_Contains "$actual" "Removing build directory"

  Assert_Match "$actual" "Package: .+\.zip"
  Assert_Match "$actual" "Docker image: .+\.tar\.xz"

  local package=$(echo "$actual" | grep --only-matching --max-count=1 "Package: .*\.zip" | sed -E "s/Package: (.+\.zip)/\1/")
  local dockerImage=$(echo "$actual" | grep --only-matching --max-count=1 "Docker image: .*\.tar\.xz" | sed -E "s/Docker image: (.+\.tar\.xz)/\1/")
  local version=$(echo "$package" | sed -E "s/.*\/pipeliner-([0-9]+\.[0-9]+\.[0-9]+)\.zip/\1/")

  Assert_File_Exists "$package"
  Assert_File_Exists "$dockerImage"

  #Download pipeliner from docker image
  docker stop pipeliner_e2etest > /dev/null 2>&1
  docker rm --force pipeliner_e2etest > /dev/null 2>&1
  docker run --name pipeliner_e2etest --detach=true --publish 127.0.0.1:8088:80 pipeliner:$version
  Assert_Equal $? 0
  wget --quiet --content-disposition http://127.0.0.1:8088/pipeliner.zip #will redirect to pipeliner-$version.zip
  Assert_Equal $? 0
  wget --quiet --content-disposition http://127.0.0.1:8088/install
  Assert_Equal $? 0
  docker stop pipeliner_e2etest > /dev/null 2>&1
  docker rm --force pipeliner_e2etest > /dev/null 2>&1

  local downloadedPackage=$(basename "$package")
  Assert_File_Exists "$downloadedPackage"

  #Clean
  rm "$downloadedPackage"
  rm "install"
}