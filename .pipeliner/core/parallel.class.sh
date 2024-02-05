#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh

Parallel__Temporary_Directory() {
  echo ".parallel_tmp"
}

Parallel__Temporary_Directory_Create() {
  mkdir -p $(Parallel__Temporary_Directory) > /dev/null 2>&1
}

Parallel__Temporary_Directory_Remove() {
  rm -rf $(Parallel__Temporary_Directory) > /dev/null 2>&1
}


Parallel__Command_Start()
{
  local command=$1
  local id=$2

  echo $command > $(Parallel__Temporary_Directory)/$id.cmd
  $command > $(Parallel__Temporary_Directory)/$id.log 2>&1 &
  echo $! > $(Parallel__Temporary_Directory)/$id.pid
}


Parallel__Batch_Determine() {
  local batchSize=$1
  local jobsSize=$2

  expr \( $jobsSize + $batchSize - 1 \) / $batchSize
}

Parallel__Batch_Start() {
  local batchID=$1
  local batchSize=$2
  shift 2
  local commands=("$@")

  local jobStartID=$(( ( ( $batchID - 1 ) * $batchSize ) + 1 ))
  local jobEndID=$(( $jobStartID + ( $batchSize - 1) ))

  for jobID in $(seq $jobStartID $jobEndID); do
    if [ $jobID -gt ${#commands[@]} ]; then
      break
    fi

    Parallel__Command_Start "${commands[$(($jobID-1))]}" $jobID
  done
}

Parallel__Batch_Wait() {
  for pidFile in $(ls $(Parallel__Temporary_Directory)/*.pid); do
    local pid=$(cat $pidFile)
    local jobID=$(basename $pidFile .pid)

    wait $pid
    echo $? > $(Parallel__Temporary_Directory)/$jobID.exit
  done
}

Parallel__Batch_Results() {
  for logFile in $(ls $(Parallel__Temporary_Directory)/*.log); do
    local jobID=$(basename $logFile .log)
    local command=$(cat $(Parallel__Temporary_Directory)/$jobID.cmd)
    local pid=$(cat $(Parallel__Temporary_Directory)/$jobID.pid)
    local exitCode=$(cat $(Parallel__Temporary_Directory)/$jobID.exit)

    Log_Group "Job #$jobID: $command"
    cat $logFile
    Log_Info "Exit code: $exitCode, PID: $pid"
    Log_Group_End
  done
}

Parallel__Batch_Failures() {
  for exitFile in $(ls $(Parallel__Temporary_Directory)/*.exit); do
    local exitCode=$(cat $exitFile)
    if [ $exitCode -ne 0 ]; then
      return 1
    fi
  done

  return 0
}

Parallel_Run() {
  local batchSize=$1
  shift
  local commands=("$@")

  local failed=0
  Parallel__Temporary_Directory_Remove
  for batchID in $(seq 1 $(Parallel__Batch_Determine $batchSize ${#commands[@]})); do
    Parallel__Temporary_Directory_Create

    Parallel__Batch_Start $batchID $batchSize "${commands[@]}"
    Parallel__Batch_Wait
    Parallel__Batch_Results

    Parallel__Batch_Failures
    if [ $? != 0 ]; then
      failed=1
    fi

    Parallel__Temporary_Directory_Remove
  done

  return $failed
}