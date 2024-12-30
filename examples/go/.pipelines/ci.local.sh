#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../../.pipeliner/init

mode=$1
apps=$(Go_Pipelines_Affected "$mode")

for app in $apps; do
  echo
  Log_Warning "Running CI pipline for $app"
  Go_Pipelines_Test $app
  Go_Pipelines_Build $app
  Log_Info "CI pipline for $app done"
  echo
done
