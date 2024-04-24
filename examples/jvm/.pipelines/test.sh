#!/bin/bash

JVM_Pipelines_Test() {
  local app=$1

  JVM_Gradle_Test $app
}