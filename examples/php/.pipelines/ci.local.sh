#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/../../../.pipeliner/init.sh

mode=$1
apps=$(PHP_Pipelines_Affected "$mode")

for app in $apps; do
  echo
  Log_Warning "Running CI pipline for $app"
  PHP_Pipelines_Stage_Test $app
  PHP_Pipelines_Stage_Build $app
  Log_Info "CI pipline for $app done"
  echo
done