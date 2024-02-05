#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../.pipeliner/init.sh

Version_BuildId_Next

echo
Pipeliner_Test_Run
if [ $? != 0 ]; then exit 1 ; fi