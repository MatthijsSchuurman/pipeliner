#!/bin/bash

source $(Files_Path_Pipeliner)/core/parallel.class.sh


UnitTest_Parallel__Temporary_Directory() {
  #Given
  local actual=

  #When
  actual=$(Parallel__Temporary_Directory)

  #Then
  Assert_Match "$actual" ".parallel_tmp"
}

UnitTest_Parallel__Temporary_Directory_Create() {
  #Given

  #When
  local actual=$(Parallel__Temporary_Directory_Create)

  #Then
  Assert_Match "$actual" ""
  Assert_Directory_Exists "$(Parallel__Temporary_Directory)"

  #Clean
  rm -R "$(Parallel__Temporary_Directory)"
}

UnitTest_Parallel__Temporary_Directory_Remove() {
  #Given
  Parallel__Temporary_Directory_Create

  #When
  local actual=$(Parallel__Temporary_Directory_Remove)

  #Then
  Assert_Match "$actual" ""
  Assert_Not_Directory_Exists "$(Parallel__Temporary_Directory)"
}


UnitTest_Parallel__Command_Start() {
  #Given
  local job="echo test"
  local jobID=1

  Parallel__Temporary_Directory_Create

  #When
  local actual=$(Parallel__Command_Start "$job" $jobID)
  wait

  #Then
  Assert_Match "$actual" ""

  Assert_File_Exists "$(Parallel__Temporary_Directory)/$jobID.cmd"
  Assert_Contains "$(cat $(Parallel__Temporary_Directory)/$jobID.cmd)" "echo test"

  Assert_File_Exists "$(Parallel__Temporary_Directory)/$jobID.log"
  Assert_Contains "$(cat $(Parallel__Temporary_Directory)/$jobID.log)" "test"

  Assert_File_Exists "$(Parallel__Temporary_Directory)/$jobID.pid"
  Assert_Match "$(cat $(Parallel__Temporary_Directory)/$jobID.pid)" "^[0-9]+$"

  #Clean
  Parallel__Temporary_Directory_Remove
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

  Parallel__Temporary_Directory_Create

  #When
  local actual=$(Parallel__Batch_Start $batchID $batchSize "${commands[@]}")

  #Then
  Assert_Match "$actual" ""

  Assert_File_Exists "$(Parallel__Temporary_Directory)/1.log"
  Assert_File_Exists "$(Parallel__Temporary_Directory)/2.log"
  Assert_Not_File_Exists "$(Parallel__Temporary_Directory)/3.log"

  #Clean
  Parallel__Temporary_Directory_Remove

  #Given
  batchID=2
  Parallel__Temporary_Directory_Create

  #When
  actual=$(Parallel__Batch_Start $batchID $batchSize "${commands[@]}")

  #Then
  Assert_Match "$actual" ""

  Assert_Not_File_Exists "$(Parallel__Temporary_Directory)/1.log"
  Assert_Not_File_Exists "$(Parallel__Temporary_Directory)/2.log"
  Assert_File_Exists "$(Parallel__Temporary_Directory)/3.log"
  Assert_Not_File_Exists "$(Parallel__Temporary_Directory)/4.log"
  Assert_Not_File_Exists "$(Parallel__Temporary_Directory)/5.log"

  #Clean
  Parallel__Temporary_Directory_Remove
}

UnitTest_Parallel__Batch_Wait() {
  #Given
  Parallel__Temporary_Directory_Create
  Parallel__Command_Start "echo test1" 1
  Parallel__Command_Start "echo test2" 2
  Parallel__Command_Start "echo test3" 3
  Parallel__Command_Start "exit 1" 4

  #When
  local actual=$(Parallel__Batch_Wait)

  #Then
  Assert_Match "$actual" ""

  Assert_File_Exists "$(Parallel__Temporary_Directory)/1.exit"
  Assert_Match "$(cat $(Parallel__Temporary_Directory)/1.exit)" 0

  Assert_File_Exists "$(Parallel__Temporary_Directory)/2.exit"
  Assert_Match "$(cat $(Parallel__Temporary_Directory)/2.exit)" 0

  Assert_File_Exists "$(Parallel__Temporary_Directory)/3.exit"
  Assert_Match "$(cat $(Parallel__Temporary_Directory)/3.exit)" 0

  Assert_File_Exists "$(Parallel__Temporary_Directory)/4.exit"
  Assert_Match "$(cat $(Parallel__Temporary_Directory)/4.exit)" 1

  #Clean
  Parallel__Temporary_Directory_Remove
}

UnitTest_Parallel__Batch_Results() {
  #Given
  Parallel__Temporary_Directory_Create

  echo cmd1 > $(Parallel__Temporary_Directory)/1.cmd
  echo log1 > $(Parallel__Temporary_Directory)/1.log
  echo 1 > $(Parallel__Temporary_Directory)/1.pid
  echo 1 > $(Parallel__Temporary_Directory)/1.exit

  echo cmd2 > $(Parallel__Temporary_Directory)/2.cmd
  echo log2 > $(Parallel__Temporary_Directory)/2.log
  echo 2 > $(Parallel__Temporary_Directory)/2.pid
  echo 2 > $(Parallel__Temporary_Directory)/2.exit

  echo cmd3 > $(Parallel__Temporary_Directory)/3.cmd
  echo log3 > $(Parallel__Temporary_Directory)/3.log
  echo 3 > $(Parallel__Temporary_Directory)/3.pid
  echo 3 > $(Parallel__Temporary_Directory)/3.exit

  #When
  local actual=$(Parallel__Batch_Results)

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
  Parallel__Temporary_Directory_Remove
}

UnitTest_Parallel__Batch_Failures() {
  #Given
  local actual=

  Parallel__Temporary_Directory_Create
  echo 0 > $(Parallel__Temporary_Directory)/1.exit
  echo 0 > $(Parallel__Temporary_Directory)/2.exit
  echo 0 > $(Parallel__Temporary_Directory)/3.exit

  #When
  actual=$(Parallel__Batch_Failures)
  local exitCode=$?

  #Then
  Assert_Match "$actual" ""
  Assert_Match $exitCode 0

  #Clean
  Parallel__Temporary_Directory_Remove


  #Given
  Parallel__Temporary_Directory_Create
  echo 0 > $(Parallel__Temporary_Directory)/1.exit
  echo 1 > $(Parallel__Temporary_Directory)/2.exit
  echo 0 > $(Parallel__Temporary_Directory)/3.exit

  #When
  actual=$(Parallel__Batch_Failures)
  exitCode=$?

  #Then
  Assert_Match "$actual" ""
  Assert_Match $exitCode 1

  #Clean
  Parallel__Temporary_Directory_Remove
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

  Assert_Not_Directory_Exists "$(Parallel__Temporary_Directory)"
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
  Assert_Between 1 $duration 2
}