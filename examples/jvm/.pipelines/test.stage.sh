#!/bin/bash

JVM_Pipelines_Stage_Test() {
  local app=$1

  JVM_Gradle_Test $app
}