#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../.pipeliner/init

Environment_Platform
if [ $(Environment_Platform) == "local" ]; then
  Version_BuildId_Next
fi

echo
Pipeliner_Test_Run unit
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Test_Run integration
if [ $? != 0 ]; then exit 1 ; fi