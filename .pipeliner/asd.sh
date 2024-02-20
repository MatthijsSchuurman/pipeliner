#!/bin/bash
#source $(dirname ${BASH_SOURCE[0]})/init.sh
source $(Files_Path_Pipeliner)/core/docker.class.sh
source $(Files_Path_Pipeliner)/core/ssh.class.sh
source $(Files_Path_Pipeliner)/core/parallel.class.sh
source $(Files_Path_Pipeliner)/core/log.class.sh



LSASD() {
  Log_Group ASD
  ls -la
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_Callback() {
  local callback=$1

  Log_Group ASDc
  eval "$callback 'ls -la'"
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_Docker() {
  Log_Group ASD
  Docker_Runner core "$(Files_Path_Work)" "" "ls -la"
  local exitCode=$?
  Log_Group_End

  return $exitCode
}

LSASD_SSH() {
  Log_Group ASD
  SSH_Run "localhost?key=asd" "ls -la"
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

