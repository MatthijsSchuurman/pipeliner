#!/bin/bash

Node_Pipelines_Stage_Test() {
  local app=$1

  Node_NPM_Test $app
  Node_NPM_Lint $app
}