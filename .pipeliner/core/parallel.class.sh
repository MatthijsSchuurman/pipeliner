#!/bin/bash

source $(Files_Path_Pipeliner)/core/log.class.sh
source $(Files_Path_Pipeliner)/core/files.class.sh


Parallel__Command_Start() {
  local tempDirectory=$1
  local command=$2
  local id=$3

  echo $command > "$tempDirectory/$id.cmd"
  $command > "$tempDirectory/$id.log" 2>&1 &
  echo $! > "$tempDirectory/$id.pid"
}

Parallel__Batch_Determine() {
  local batchSize=$1
  local jobsSize=$2

  expr \( $jobsSize + $batchSize - 1 \) / $batchSize
}

Parallel__Batch_Start() {
  local tempDirectory=$1
  local batchID=$2
  local batchSize=$3
  shift 3
  local commands=("$@")

  local jobStartID=$(( ( ( $batchID - 1 ) * $batchSize ) + 1 ))
  local jobEndID=$(( $jobStartID + ( $batchSize - 1) ))

  for jobID in $(seq $jobStartID $jobEndID); do
    if [ $jobID -gt ${#commands[@]} ]; then
      break
    fi

    Parallel__Command_Start "$tempDirectory" "${commands[$(($jobID-1))]}" $jobID
  done
}

Parallel__Batch_Wait() {
  local tempDirectory=$1

  for pidFile in $(ls "$tempDirectory/"*.pid); do
    local pid=$(cat $pidFile)
    local jobID=$(basename $pidFile .pid)

    wait $pid
    echo $? > "$tempDirectory/$jobID.exit"
  done
}

Parallel__Batch_Results() {
  local tempDirectory=$1

  for logFile in $(ls "$tempDirectory/"*.log); do
    local jobID=$(basename $logFile .log)
    local command=$(cat "$tempDirectory/$jobID.cmd")
    local pid=$(cat "$tempDirectory/$jobID.pid")
    local exitCode=$(cat "$tempDirectory/$jobID.exit")

    Log_Group "Job #$jobID: $command"
    cat $logFile
    Log_Info "Exit code: $exitCode, PID: $pid"
    Log_Group_End
  done
}

Parallel__Batch_Failures() {
  local tempDirectory=$1

  for exitFile in $(ls "$tempDirectory/"*.exit); do
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

  for batchID in $(seq 1 $(Parallel__Batch_Determine $batchSize ${#commands[@]})); do
    local tempDirectory=$(Files_Temp_Directory parallel)
    Parallel__Batch_Start "$tempDirectory" $batchID $batchSize "${commands[@]}"
    Parallel__Batch_Wait "$tempDirectory"
    Parallel__Batch_Results "$tempDirectory"

    Parallel__Batch_Failures "$tempDirectory"
    if [ $? != 0 ]; then
      failed=1
    fi

    rm -R "$tempDirectory"
  done

  return $failed
}