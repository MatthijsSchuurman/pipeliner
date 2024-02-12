#!/bin/bash
source $(dirname ${BASH_SOURCE[0]})/init.sh

LSASD() {
  Log_Group ASD
  ls -la
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_Docker() {
  Log_Group ASD
  Docker_Runner core "ls -la" "$(Files_Path_Work)"
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_SSH() {
  Log_Group ASD
  SSH_Run localhost "ls -la" asd
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_Parallel() {
  Log_Group ASD
  Parallel_Run 5 "ls -la"
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

