#!/bin/bash

source $(Files_Path_Pipeliner)/core/parallel.class.sh


UnitTest_Parallel__Command_Start() {
  #Given
  local job="echo test"
  local jobID=1

  local tempDirectory=$(Files_Temp_Directory test)

  #When
  local actual=$(Parallel__Command_Start "$tempDirectory" "$job" $jobID)
  wait

  #Then
  Assert_Empty "$actual"

  Assert_File_Exists "$tempDirectory/$jobID.cmd"
  Assert_Contains "$(cat $tempDirectory/$jobID.cmd)" "echo test"

  Assert_File_Exists "$tempDirectory/$jobID.log"
  Assert_Contains "$(cat $tempDirectory/$jobID.log)" "test"

  Assert_File_Exists "$tempDirectory/$jobID.pid"
  Assert_Match "$(cat $tempDirectory/$jobID.pid)" "^[0-9]+$"

  #Clean
  rm -Rf "$tempDirectory"
}


UnitTest_Parallel__Batch_Determine() {
  #When
  actual=$(Parallel__Batch_Determine 2 6)

  #Then
  Assert_Match $actual 3

  #When
  actual=$(Parallel__Batch_Determine 2 5)

  #Then
  Assert_Match $actual 3

  #When
  actual=$(Parallel__Batch_Determine 2 4)

  #Then
  Assert_Match $actual 2

  #When
  actual=$(Parallel__Batch_Determine 2 1)

  #Then
  Assert_Match $actual 1
}


UnitTest_Parallel__Batch_Start() {
  #Given
  local batchID=1
  local batchSize=2
  local commands=("echo test1" "echo test2" "echo test3")

  local tempDirectory=$(Files_Temp_Directory test)

  #When
  local actual=$(Parallel__Batch_Start "$tempDirectory" $batchID $batchSize "${commands[@]}")

  #Then
  Assert_Empty "$actual"

  Assert_File_Exists "$tempDirectory/1.log"
  Assert_File_Exists "$tempDirectory/2.log"
  Assert_Not_File_Exists "$tempDirectory/3.log"

  #Clean
  rm -Rf "$tempDirectory"

  #Given
  batchID=2
  local tempDirectory=$(Files_Temp_Directory test)

  #When
  actual=$(Parallel__Batch_Start "$tempDirectory" $batchID $batchSize "${commands[@]}")

  #Then
  Assert_Empty "$actual"

  Assert_Not_File_Exists "$tempDirectory/1.log"
  Assert_Not_File_Exists "$tempDirectory/2.log"
  Assert_File_Exists "$tempDirectory/3.log"
  Assert_Not_File_Exists "$tempDirectory/4.log"
  Assert_Not_File_Exists "$tempDirectory/5.log"

  #Clean
  rm -Rf "$tempDirectory"
}

UnitTest_Parallel__Batch_Wait() {
  #Given
  local tempDirectory=$(Files_Temp_Directory test)
  Parallel__Command_Start "$tempDirectory" "echo test1" 1
  Parallel__Command_Start "$tempDirectory" "echo test2" 2
  Parallel__Command_Start "$tempDirectory" "echo test3" 3
  Parallel__Command_Start "$tempDirectory" "exit 1" 4

  #When
  local actual=$(Parallel__Batch_Wait "$tempDirectory")

  #Then
  Assert_Empty "$actual"

  Assert_File_Exists "$tempDirectory/1.exit"
  Assert_Match "$(cat $tempDirectory/1.exit)" 0

  Assert_File_Exists "$tempDirectory/2.exit"
  Assert_Match "$(cat $tempDirectory/2.exit)" 0

  Assert_File_Exists "$tempDirectory/3.exit"
  Assert_Match "$(cat $tempDirectory/3.exit)" 0

  Assert_File_Exists "$tempDirectory/4.exit"
  Assert_Match "$(cat $tempDirectory/4.exit)" 1

  #Clean
  rm -Rf "$tempDirectory"
}

UnitTest_Parallel__Batch_Results() {
  #Given
  local tempDirectory=$(Files_Temp_Directory test)

  echo cmd1 > $tempDirectory/1.cmd
  echo log1 > $tempDirectory/1.log
  echo 1 > $tempDirectory/1.pid
  echo 1 > $tempDirectory/1.exit

  echo cmd2 > $tempDirectory/2.cmd
  echo log2 > $tempDirectory/2.log
  echo 2 > $tempDirectory/2.pid
  echo 2 > $tempDirectory/2.exit

  echo cmd3 > $tempDirectory/3.cmd
  echo log3 > $tempDirectory/3.log
  echo 3 > $tempDirectory/3.pid
  echo 3 > $tempDirectory/3.exit

  #When
  local actual=$(Parallel__Batch_Results "$tempDirectory")

  #Then
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$actual" GROUP "Job #1: cmd1" "log1" "Exit code: 1, PID: 1" ENDGROUP
    Assert_Match "$actual" GROUP "Job #2: cmd2" "log2" "Exit code: 2, PID: 2" ENDGROUP
    Assert_Match "$actual" GROUP "Job #3: cmd3" "log3" "Exit code: 3, PID: 3" ENDGROUP
  else
    Assert_Match "$actual" group "Job #1: cmd1" "log1" "Exit code: 1, PID: 1" endgroup
    Assert_Match "$actual" group "Job #2: cmd2" "log2" "Exit code: 2, PID: 2" endgroup
    Assert_Match "$actual" group "Job #3: cmd3" "log3" "Exit code: 3, PID: 3" endgroup
  fi

  #Clean
  rm -Rf "$tempDirectory"
}

UnitTest_Parallel__Batch_Failures() {
  #Given
  local actual=

  local tempDirectory=$(Files_Temp_Directory test)
  echo 0 > $tempDirectory/1.exit
  echo 0 > $tempDirectory/2.exit
  echo 0 > $tempDirectory/3.exit

  #When
  actual=$(Parallel__Batch_Failures "$tempDirectory")
  local exitCode=$?

  #Then
  Assert_Empty "$actual"
  Assert_Match $exitCode 0

  #Clean
  rm -Rf "$tempDirectory"


  #Given
  local tempDirectory=$(Files_Temp_Directory test)
  echo 0 > $tempDirectory/1.exit
  echo 1 > $tempDirectory/2.exit
  echo 0 > $tempDirectory/3.exit

  #When
  actual=$(Parallel__Batch_Failures "$tempDirectory")
  exitCode=$?

  #Then
  Assert_Empty "$actual"
  Assert_Match $exitCode 1

  #Clean
  rm -Rf "$tempDirectory"
}

UnitTest_Parallel_Run() {
  #Given
  local value=
  local batchSize=3
  local commands=("echo test1" "echo test2" "echo test3" "exit 1" "echo test5" "echo test6" "echo test7")

  #When
  value=$(Parallel_Run $batchSize "${commands[@]}")
  local exitCode=$?

  #Then
  Assert_Match $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Match "$value" GROUP "Job #1: echo test1" "test1" "Exit code: 0, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #2: echo test2" "test2" "Exit code: 0, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #3: echo test3" "test3" "Exit code: 0, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #4: exit 1" "Exit code: 1, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #5: echo test5" "test5" "Exit code: 0, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #6: echo test6" "test6" "Exit code: 0, PID: [0-9]+" ENDGROUP
    Assert_Match "$value" GROUP "Job #7: echo test7" "test7" "Exit code: 0, PID: [0-9]+" ENDGROUP
  else
    Assert_Match "$value" group "Job #1: echo test1" "test1" "Exit code: 0, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #2: echo test2" "test2" "Exit code: 0, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #3: echo test3" "test3" "Exit code: 0, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #4: exit 1" "Exit code: 1, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #5: echo test5" "test5" "Exit code: 0, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #6: echo test6" "test6" "Exit code: 0, PID: [0-9]+" endgroup
    Assert_Match "$value" group "Job #7: echo test7" "test7" "Exit code: 0, PID: [0-9]+" endgroup
  fi

  parallelDirectories=$(ls -l $(Files_Temp__Dir)/parallel* 2> /dev/null | wc -l)
  Assert_Equal $parallelDirectories 0
}

UnitTest_Parallel_Run_sleep() {
  #Given
  local value=
  local batchSize=6 #2 batches of each 0.5 seconds
  local commands=("sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5" "sleep 0.5")

  #When
  local startSeconds=$SECONDS
  value=$(Parallel_Run $batchSize "${commands[@]}")
  local endSeconds=$SECONDS
  local duration=$((endSeconds - startSeconds))

  #Then
  Assert_Between 1 $duration 3
}