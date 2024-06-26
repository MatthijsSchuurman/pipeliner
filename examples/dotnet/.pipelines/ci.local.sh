#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../../.pipeliner/init

mode=$1
apps=$(DotNet_Pipelines_Affected "$mode")

for app in $apps; do
  echo
  Log_Warning "Running CI pipline for $app"
  DotNet_Pipelines_Test $app
  DotNet_Pipelines_Build $app
  Log_Info "CI pipline for $app done"
  echo
done