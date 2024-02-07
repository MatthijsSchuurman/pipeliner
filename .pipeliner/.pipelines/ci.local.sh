#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../.pipeliner/init.sh

Version_BuildId_Next

echo
Pipeliner_Test_Run unit
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Test_Run integration
if [ $? != 0 ]; then exit 1 ; fi

echo
Pipeliner_Test_Run e2e
if [ $? != 0 ]; then exit 1 ; fi