#!/bin/bash

PHP_Pipelines_Stage_Test() {
  local app=$1

  PHP_Composer_Test $app
  PHP_Lint $app
}