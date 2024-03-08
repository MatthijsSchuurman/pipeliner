#!/bin/bash

source $(Files_Path_Pipeliner)/core/utils/dictionary.class.sh

UnitTest_Dictionary_Exists() {
  #Given
  local dictionary="key: value"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Exists "$dictionary" "key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key: value
key2: value2"

  #When
  actual=$(Dictionary_Exists "$dictionary" "key2")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key: value
keykey: value2"

  #When
  actual=$(Dictionary_Exists "$dictionary" "key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key: value
-arg: argvalue"

  #When
  actual=$(Dictionary_Exists "$dictionary" "-arg")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key: value
key2: value2"

  #When
  actual=$(Dictionary_Exists "$dictionary" "key3")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Empty "$actual"


  #Given
  local dictionary="0: value
1: value2"

  #When
  actual=$(Dictionary_Exists "$dictionary" "0")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key/1: value/1
key/2: value/2"

  #When
  actual=$(Dictionary_Exists "$dictionary" "key/1")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"
}


UnitTest_Dictionary_Keys() {
  #Given
  local dictionary="key: value
key2: value2
-arg: argvalue
0: value3
1: value4
key/1: value/1"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Keys "$dictionary")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Contains "$actual" "key"
  Assert_Contains "$actual" "key2"
  Assert_Contains "$actual" "-arg"
  Assert_Contains "$actual" "0"
  Assert_Contains "$actual" "1"
  Assert_Contains "$actual" "key/1"
}

UnitTest_Dictionary_Keys_Fail() {
  #Given
  local dictionary=

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Keys "$dictionary")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"
}

UnitTest_Dictionary_Set() {
  #Given
  local dictionary=
  local key="key"
  local value="value"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value"


  #Given
  local dictionary="key: value"
  local key="key2"
  local value="value2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
key2: value2"


  #Given
  local dictionary="key: value"
  local key="keykey"
  local value="value2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
keykey: value2"


  #Given
  local dictionary="key: value"
  local key="-arg"
  local value="argvalue"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
-arg: argvalue"


  #Given
  local dictionary="key: value"
  local key="0"
  local value="indexvalue"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
0: indexvalue"


  #Given
  local dictionary=
  local key="key"
  local value="value/1"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value/1"


  #Given
  local dictionary="key/1: value"
  local key="key/1"
  local value="value1"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key/1: value1"


  #Given
  local dictionary="key: value/1"
  local key="key"
  local value="value/2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value/2"
}

UnitTest_Dictionary_Set_Overwrite() {
  #Given
  local dictionary="key: value"
  local key="key"
  local value="value2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value2"


  #Given
  local dictionary="key: value
key2: value2"
  local key="key2"
  local value="value3"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
key2: value3"


  #Given
  local dictionary="key: value
keykey: value2"
  local key="key"
  local value="value3"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value3
keykey: value2"


  #Given
  local dictionary="key: value
-arg: argvalue"
  local key="-arg"
  local value="argvalue2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
-arg: argvalue2"


  #Given
  local dictionary="key: value
0: indexvalue"
  local key="0"
  local value="indexvalue2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
0: indexvalue2"
}

UnitTest_Dictionary_Set_Fail() {
  #Given
  local actual=
  local exitCode=

  local dictionary=
  local key="key: value"
  local value="value"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key: value' contains colon character"


  #Given
  local dictionary=
  local key="key
key2"
  local value="value"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key
key2' contains new line character"


  #Given
  local dictionary=
  local key="key"
  local value="value
value2"

  #When
  actual=$(Dictionary_Set "$dictionary" "$key" "$value" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary value 'value
value2' contains new line character"
}

UnitTest_Dictionary_Unset() {
  #Given
  local actual=
  local exitCode=

  local dictionary="key: value"
  local key="key"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Empty "$actual"


  #Given
  local dictionary="key: value
key2: value2
key3: value3"
  local key="key2"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value
key3: value3"


  #Given
  local dictionary="key: value
keykey: value2
key3: value3"

  #When
  actual=$(Dictionary_Unset "$dictionary" "key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "keykey: value2
key3: value3"


  #Given
  local dictionary="key: value
-arg: argvalue"
  local key="-arg"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value"


  #Given
  local dictionary="key: value
0: indexvalue"
  local key="0"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "key: value"
}

UnitTest_Dictionary_Unset_Fail() {
  #Given
  local actual=
  local exitCode=

  local dictionary="key: value"
  local key="key2"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key2' not found"


  #Given
  local dictionary="key: value"
  local key="key
key2"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key
key2' contains new line character"


  #Given
  local dictionary="key: value"
  local key="key: value"

  #When
  actual=$(Dictionary_Unset "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key: value' contains colon character"
}

UnitTest_Dictionary_Get() {
  #Given
  local actual=
  local exitCode=

  local dictionary="key: value"
  local key="key"

  #When
  actual=$(Dictionary_Get "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "value"


  #Given
  local dictionary="key: value
keykey: value2"

  #When
  actual=$(Dictionary_Get "$dictionary" "key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "value"


  #Given
  local dictionary="key: value
-arg: argvalue"
  local key="-arg"

  #When
  actual=$(Dictionary_Get "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "argvalue"


  #Given
  local dictionary="key: value
0: indexvalue"
  local key="0"

  #When
  actual=$(Dictionary_Get "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "indexvalue"


  #Given
  local dictionary="url: https://example.com/api"
  local key="url"

  #When
  actual=$(Dictionary_Get "$dictionary" "$key")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Equal "$actual" "https://example.com/api"
}

UnitTest_Dictionary_Get_Fail() {
  #Given
  local dictionary="key: value"
  local key="key2"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Get "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key2' not found"


  #Given
  local dictionary="key: value"
  local key="key
key2"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Get "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key
key2' contains new line character"


  #Given
  local dictionary="key: value"
  local key="key: value"

  local actual=
  local exitCode=

  #When
  actual=$(Dictionary_Get "$dictionary" "$key" 2>&1)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  Assert_Equal "$actual" "Dictionary key 'key: value' contains colon character"
}
