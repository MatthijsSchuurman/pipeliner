#!/bin/bash

DotNet_Pipelines_Stage_Test() {
  local app=$1

  DotNet_Test $app
  DotNet_Lint $app
}