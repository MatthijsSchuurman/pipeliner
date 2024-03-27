#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../.pipeliner/init

Environment_Platform
if [ $(Environment_Platform) == "local" ]; then
  Version_BuildId_Next
fi

echo
Pipeliner_Test_Run e2e
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Package_Create
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Docker_Create_Image $(Variables_Get package)
if [ $? != 0 ]; then exit 1 ; fi