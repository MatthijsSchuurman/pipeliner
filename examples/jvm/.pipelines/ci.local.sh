#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../../.pipeliner/init

mode=$1
apps=$(JVM_Pipelines_Affected "$mode")

for app in $apps; do
  echo
  Log_Warning "Running CI pipline for $app"
  JVM_Pipelines_Test $app
  JVM_Pipelines_Build $app
  Log_Info "CI pipline for $app done"
  echo
done