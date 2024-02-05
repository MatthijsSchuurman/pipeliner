#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../.pipeliner/init.sh

Version_BuildId_Next

echo
Pipeliner_Package_Create
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Docker_Create_Image $(Variables_Get package)
if [ $? != 0 ]; then exit 1 ; fi