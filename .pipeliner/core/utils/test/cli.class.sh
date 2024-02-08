#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/cli.class.sh

UnitTest_CLI_Arguments() {
  #Given
  local actual=
  local argumentsDefinition="-a: alpha #Alias for --alpha
-b: beta #Alias for --beta
-g: gamma #Alias for --gamma
--alpha: alpha #Alpha description
--beta: beta #Beta description
--gamma: gamma #Gamma description"

  #When
  actual=$(CLI_Arguments "$argumentsDefinition" -a 1 -b 2 -g 3 --alpha 4 --beta 5 --gamma 6 7 8 9)

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 9
  Assert_Contains "$(Dictionary_Keys "$actual")" "alpha,0" "alpha,1" "beta,0" "beta,1" "gamma,0" "gamma,1" "0" "1" "2"

  Assert_Equal "$(Dictionary_Get "$actual" "alpha,0")" 1
  Assert_Equal "$(Dictionary_Get "$actual" "alpha,1")" 4
  Assert_Equal "$(Dictionary_Get "$actual" "beta,0")" 2
  Assert_Equal "$(Dictionary_Get "$actual" "beta,1")" 5
  Assert_Equal "$(Dictionary_Get "$actual" "gamma,0")" 3
  Assert_Equal "$(Dictionary_Get "$actual" "gamma,1")" 6
  Assert_Equal "$(Dictionary_Get "$actual" "0")" 7
  Assert_Equal "$(Dictionary_Get "$actual" "1")" 8
  Assert_Equal "$(Dictionary_Get "$actual" "2")" 9


  #Given
  local argumentsDefinition="--file: file
-f: file
--boolean: boolean
-b: boolean
"

  #When
  actual=$(CLI_Arguments "$argumentsDefinition" --file somefile.txt -b -f someotherfile.txt separatefile.txt --file yetanotherfile.txt --boolean)

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 6
  Assert_Contains "$(Dictionary_Keys "$actual")" "file,0" "file,1" "file,2" "boolean,0" "0" "1"

  Assert_Equal "$(Dictionary_Get "$actual" "file,0")" "somefile.txt"
  Assert_Equal "$(Dictionary_Get "$actual" "file,1")" "someotherfile.txt"
  Assert_Equal "$(Dictionary_Get "$actual" "file,2")" "yetanotherfile.txt"
  Assert_Equal "$(Dictionary_Get "$actual" "boolean,0")" TRUE
  Assert_Equal "$(Dictionary_Get "$actual" "boolean,1")" TRUE
  Assert_Equal "$(Dictionary_Get "$actual" "0")" separatefile.txt


  #Given
  local argumentsDefinition="--file: file"

  #When
  actual=$(CLI_Arguments "$argumentsDefinition" --file somefile.txt "command --with-argument" --file someotherfile.txt)

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 3
  Assert_Contains "$(Dictionary_Keys "$actual")" "file,0" "file,1" "0"

  Assert_Equal "$(Dictionary_Get "$actual" "file,0")" "somefile.txt"
  Assert_Equal "$(Dictionary_Get "$actual" "file,1")" "someotherfile.txt"
  Assert_Equal "$(Dictionary_Get "$actual" "0")" "command --with-argument"
}

UnitTest_CLI_Arguments_Fail() {
  #Given
  local argumentsDefinition="--known: known"

  local actual=

  #When
  local logFile=$(Files_Temp_File test .log)
  actual=$(CLI_Arguments "$argumentsDefinition" --unknown 2>$logFile) #don't capture stdout but only stderr
  local stderr=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 1
  Assert_Contains "$(Dictionary_Keys "$actual")" "FAILURES"

  Assert_Equal "$(Dictionary_Get "$actual" "FAILURES")" "1"
  Assert_Contains "$stderr" "Unknown argument: --unknown"
}

UnitTest_CLI_Arguments_Usage() {
  #Given
  local actual=
  local argumentsDefinition="-a: alpha #Alias for --alpha
-b: beta #Alias for --beta
-g: gamma #Alias for --gamma
--alpha: alpha #Alpha description
--beta: beta #Beta description
--gamma: gamma #Gamma description
"

  #When
  actual=$(CLI_Arguments_Usage "test.sh" "$argumentsDefinition")

  #Then
  Assert_Contains "$actual" "Usage:" "test.sh" "options"
  Assert_Contains "$actual" "-a" "Alias for --alpha"
  Assert_Contains "$actual" "-b" "Alias for --beta"
  Assert_Contains "$actual" "-g" "Alias for --gamma"
  Assert_Contains "$actual" "--alpha" "Alpha description"
  Assert_Contains "$actual" "--beta" "Beta description"
  Assert_Contains "$actual" "--gamma" "Gamma description"
}


UnitTest_CLI_Arguments__Parse_Mapping() {
  #Given
  local actual=
  local argumentsDefinition="-a: alpha #Alias for --alpha
-b: beta #Alias for --beta
-g: gamma #Alias for --gamma
--alpha: alpha #Alpha description
--beta: beta #Beta description
--gamma: gamma #Gamma description
"

  #When
  actual=$(CLI_Arguments__Parse_Mapping "$argumentsDefinition")

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 6
  Assert_Contains "$(Dictionary_Keys "$actual")" "-a" "-b" "-g" "--alpha" "--beta" "--gamma"

  Assert_Equal "$(Dictionary_Get "$actual" "-a")" "alpha"
  Assert_Equal "$(Dictionary_Get "$actual" "-b")" "beta"
  Assert_Equal "$(Dictionary_Get "$actual" "-g")" "gamma"
  Assert_Equal "$(Dictionary_Get "$actual" "--alpha")" "alpha"
  Assert_Equal "$(Dictionary_Get "$actual" "--beta")" "beta"
  Assert_Equal "$(Dictionary_Get "$actual" "--gamma")" "gamma"


  #Given
  local argumentsDefinition="-a: alpha
  -b: beta
-g: gamma   "

  #When
  actual=$(CLI_Arguments__Parse_Mapping "$argumentsDefinition")

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 3
  Assert_Contains "$(Dictionary_Keys "$actual")" "-a" "-b" "-g"

  Assert_Equal "$(Dictionary_Get "$actual" "-a")" "alpha"
  Assert_Equal "$(Dictionary_Get "$actual" "-b")" "beta"
  Assert_Equal "$(Dictionary_Get "$actual" "-g")" "gamma"
}

UnitTest_CLI_Arguments__Parse_Mapping_Fail() {
  #Given
  local actual=
  local argumentsDefinition="-a:"

  #When
  actual=$(CLI_Arguments__Parse_Mapping "$argumentsDefinition")

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 0


  #Given
  local argumentsDefinition=": alpha"

  #When
  actual=$(CLI_Arguments__Parse_Mapping "$argumentsDefinition")

  #Then
  Assert_Equal $(Dictionary_Keys "$actual" | wc -l) 0
}
