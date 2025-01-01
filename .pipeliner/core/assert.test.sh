#!/bin/bash

source $(Files_Path_Pipeliner)/core/assert.sh


# String assertions

UnitTest_Assert_Equal() {
  #Given
  local actual=

  #When
  actual=$(Assert_Equal "actual" "actual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert equal should not fail when actual and expected are equal"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert equal should not return a value when actual and expected are equal"
    exit 1
  fi
}
UnitTest_Assert_Equal_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Equal "actual" "expected")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert equal should fail when actual and expected are not equal"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to equal 'expected'" ]; then
    echo "Test failed: assert equal should return the correct value when actual and expected are not equal"
    exit 1
  fi
}

UnitTest_Assert_Not_Equal() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Equal "actual" "expected")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not equal should not fail when actual and expected are not equal"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not equal should not return a value when actual and expected are not equal"
    exit 1
  fi
}
UnitTest_Assert_Not_Equal_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Equal "actual" "actual")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not equal should fail when actual and expected are equal"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not equal 'actual'" ]; then
    echo "Test failed: assert not equal should return the correct value when actual and expected are equal"
    exit 1
  fi
}

UnitTest_Assert_Greater_Than() {
  #Given
  local actual=

  #When
  actual=$(Assert_Greater_Than 2 1)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert greater should not fail when actual is greater than expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert greater should not return a value when actual is greater than expected"
    exit 1
  fi
}
UnitTest_Assert_Greater_Than_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Greater_Than 1 2)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert greater should fail when actual is less than expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '1' to be greater than '2'" ]; then
    echo "Test failed: assert greater should return the correct value when actual is less than expected"
    exit 1
  fi

  #When
  actual=$(Assert_Greater_Than 1 1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert greater should fail when actual is equal to expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '1' to be greater than '1'" ]; then
    echo "Test failed: assert greater should return the correct value when actual is equal to expected"
    exit 1
  fi
}

UnitTest_Assert_Greater_Than_Or_Equal() {
  #Given
  local actual=

  #When
  actual=$(Assert_Greater_Than_Or_Equal 2 1)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert greater or equal should not fail when actual is greater than expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert greater or equal should not return a value when actual is greater than expected"
    exit 1
  fi

  #When
  actual=$(Assert_Greater_Than_Or_Equal 1 1)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert greater or equal should not fail when actual is equal to expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert greater or equal should not return a value when actual is equal to expected"
    exit 1
  fi
}

UnitTest_Assert_Greater_Than_Or_Equal_Fail() {
    #Given
  local actual=

  #When
  actual=$(Assert_Greater_Than_Or_Equal 1 2)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert greater should fail when actual is less than expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '1' to be greater than or equal to '2'" ]; then
    echo "Test failed: assert greater should return the correct value when actual is less than expected"
    exit 1
  fi
}

UnitTest_Assert_Less_Than() {
  #Given
  local actual=

  #When
  actual=$(Assert_Less_Than 1 2)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert less should not fail when actual is less than expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert less should not return a value when actual is less than expected"
    exit 1
  fi
}
UnitTest_Assert_Less_Than_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Less_Than 2 1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert less should fail when actual is greater than expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '2' to be less than '1'" ]; then
    echo "Test failed: assert less should return the correct value when actual is greater than expected"
    exit 1
  fi

  #When
  actual=$(Assert_Less_Than 1 1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert less should fail when actual is equal to expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '1' to be less than '1'" ]; then
    echo "Test failed: assert less should return the correct value when actual is equal to expected"
    exit 1
  fi
}

UnitTest_Assert_Less_Than_Or_Equal() {
  #Given
  local actual=

  #When
  actual=$(Assert_Less_Than_Or_Equal 1 2)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert less or equal should not fail when actual is less than expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert less or equal should not return a value when actual is less than expected"
    exit 1
  fi

  #When
  actual=$(Assert_Less_Than_Or_Equal 1 1)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert less or equal should not fail when actual is equal to expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert less or equal should not return a value when actual is equal to expected"
    exit 1
  fi
}
UnitTest_Assert_Less_Than_Or_Equal_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Less_Than_Or_Equal 2 1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert less or equal should fail when actual is greater than expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '2' to be less than or equal to '1'" ]; then
    echo "Test failed: assert less or equal should return the correct value when actual is greater than expected"
    exit 1
  fi
}


UnitTest_Assert_Between() {
  #Given
  local actual=

  #When
  actual=$(Assert_Between 1 2 3)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert between should not fail when actual is between expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert between should not return a value when actual is between expected"
    exit 1
  fi

  #When
  actual=$(Assert_Between 1 1 3)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert between should not fail when actual is equal to min"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert between should not return a value when actual is equal to min"
    exit 1
  fi

  #When
  actual=$(Assert_Between -3 0 3)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert between should not fail when actual is equal to max"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert between should not return a value when actual is equal to max"
    exit 1
  fi
}
UnitTest_Assert_Between_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Between 1 0 3)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert between should fail when actual is less than min"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '0' to be between '1' and '3'" ]; then
    echo "Test failed: assert between should return the correct value when actual is less than min"
    exit 1
  fi

  #When
  actual=$(Assert_Between 1 5 3)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert between should fail when actual is greater than max"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '5' to be between '1' and '3'" ]; then
    echo "Test failed: assert between should return the correct value when actual is greater than max"
    exit 1
  fi

  #When
  actual=$(Assert_Between -10 -100 -5)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert between should fail when actual is less than min and negative"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '-100' to be between '-10' and '-5'" ]; then
    echo "Test failed: assert between should return the correct value when actual is less than min and negative"
    exit 1
  fi
}

UnitTest_Assert_Not_Between() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Between 1 0 3)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not between should not fail when actual is less than min"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not between should not return a value when actual is less than min"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Between 1 5 3)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not between should not fail when actual is greater than max"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not between should not return a value when actual is greater than max"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Between -10 -100 -5)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not between should not fail when actual is less than min and negative"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not between should not return a value when actual is less than min and negative"
    exit 1
  fi
}
UnitTest_Assert_Not_Between_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Between 1 2 3)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not between should fail when actual is between expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '2' to not be between '1' and '3'" ]; then
    echo "Test failed: assert not between should return the correct value when actual is between expected"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Between 1 1 3)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not between should fail when actual is equal to min"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '1' to not be between '1' and '3'" ]; then
    echo "Test failed: assert not between should return the correct value when actual is equal to min"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Between -3 0 3)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not between should fail when actual is equal to max"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '0' to not be between '-3' and '3'" ]; then
    echo "Test failed: assert not between should return the correct value when actual is equal to max"
    exit 1
  fi
}


UnitTest_Assert_Match() {
  #Given
  local actual=

  #When
  actual=$(Assert_Match actual [a-z]+)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert match should not fail when actual matches expected"
    exit 1
  fi

  #When
  actual=$(Assert_Match actual act)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert match should not fail when actual matches expected"
    exit 1
  fi
}
UnitTest_Assert_Match_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Match actual [0-9]+)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert match should fail when actual does not match expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to match '[0-9]+'" ]; then
    echo "Test failed: assert match should return the correct value when actual does not match expected"
    exit 1
  fi
}

UnitTest_Assert_Not_Match() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Match actual [0-9]+)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not match should not fail when actual does not match expected"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Match actual expected)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not match should not fail when actual does not match expected"
    exit 1
  fi
}
UnitTest_Assert_Not_Match_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Match actual [a-z]+)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not match should fail when actual matches expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not match '[a-z]+'" ]; then
    echo "Test failed: assert not match should return the correct value when actual matches expected"
    exit 1
  fi
}

UnitTest_Assert_Starts_With() {
  #Given
  local actual=

  #When
  actual=$(Assert_Starts_With "actual" "actual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert starts with should not fail when actual starts with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert starts with should not return a value when actual starts with expected"
    exit 1
  fi

  #When
  actual=$(Assert_Starts_With "actual" "act")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert starts with should not fail when actual starts with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert starts with should not return a value when actual starts with expected"
    exit 1
  fi
}
UnitTest_Assert_Starts_With_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Starts_With "actual" "expected")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert starts with should fail when actual does not start with expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to start with 'expected'" ]; then
    echo "Test failed: assert starts with should return the correct value when actual does not start with expected"
    exit 1
  fi
}

UnitTest_Assert_Not_Starts_With() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Starts_With "actual" "expected")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not starts with should not fail when actual does not start with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not starts with should not return a value when actual does not start with expected"
    exit 1
  fi
}
UnitTest_Assert_Not_Starts_With_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Starts_With "actual" "actual")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not starts with should fail when actual starts with expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not start with 'actual'" ]; then
    echo "Test failed: assert not starts with should return the correct value when actual starts with expected"
    exit 1
  fi
}

UnitTest_Assert_Ends_With() {
  #Given
  local actual=

  #When
  actual=$(Assert_Ends_With "actual" "actual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert ends with should not fail when actual ends with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert ends with should not return a value when actual ends with expected"
    exit 1
  fi

  #When
  actual=$(Assert_Ends_With "actual" "ual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert ends with should not fail when actual ends with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert ends with should not return a value when actual ends with expected"
    exit 1
  fi
}
UnitTest_Assert_Ends_With_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Ends_With "actual" "expected")

  #Thenbe
  if [ $? == 0 ]; then
    echo "Test failed: assert ends with should fail when actual does not end with expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to end with 'expected'" ]; then
    echo "Test failed: assert ends with should return the correct value when actual does not end with expected"
    exit 1
  fi
}

UnitTest_Assert_Not_Ends_With() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Ends_With "actual" "expected")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not ends with should not fail when actual does not end with expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not ends with should not return a value when actual does not end with expected"
    exit 1
  fi
}
UnitTest_Assert_Not_Ends_With_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Ends_With "actual" "actual")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not ends with should fail when actual ends with expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not end with 'actual'" ]; then
    echo "Test failed: assert not ends with should return the correct value when actual ends with expected"
    exit 1
  fi
}

UnitTest_Assert_Contains() {
  #Given
  local actual=

  #When
  actual=$(Assert_Contains "actual" "actual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert contains should not fail when actual contains expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert contains should not return a value when actual contains expected"
    exit 1
  fi

  #When
  actual=$(Assert_Contains "actual" "act")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert contains should not fail when actual contains expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert contains should not return a value when actual contains expected"
    exit 1
  fi

  #When
  actual=$(Assert_Contains "actual" "act" "ual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert contains should not fail when actual contains expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert contains should not return a value when actual contains expected"
    exit 1
  fi
}
UnitTest_Assert_Contains_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Contains "actual" "actual" "expected")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert contains should fail when actual does not contain expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to contain 'expected'" ]; then
    echo "Test failed: assert contains should return the correct value when actual does not contain expected"
    exit 1
  fi

  #When
  actual=$(Assert_Contains "actual" "expected")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert contains should fail when actual does not contain expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to contain 'expected'" ]; then
    echo "Test failed: assert contains should return the correct value when actual does not contain expected"
    exit 1
  fi
}

UnitTest_Assert_Not_Contains() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Contains "actual" "expected")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not contains should not fail when actual does not contain expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not contains should not return a value when actual does not contain expected"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Contains "actual" "expected" "expected")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not contains should not fail when actual does not contain expected"
    exit 1
  fi
  if [ "$actual" ]; then
    echo "Test failed: assert not contains should not return a value when actual does not contain expected"
    exit 1
  fi
}
UnitTest_Assert_Not_Contains_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Contains "actual" "actual")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not contains should fail when actual contains expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not contain 'actual'" ]; then
    echo "Test failed: assert not contains should return the correct value when actual contains expected"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Contains "actual" "act")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not contains should fail when actual contains expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to not contain 'act'" ]; then
    echo "Test failed: assert not contains should return the correct value when actual contains expected"
    exit 1
  fi
}

UnitTest_Assert_Empty() {
  #Given
  local actual=

  #When
  actual=$(Assert_Empty "")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert empty should not fail when actual is empty"
    exit 1
  fi
}
UnitTest_Assert_Empty_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Empty "actual")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert empty should fail when actual is not empty"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected 'actual' to be empty" ]; then
    echo "Test failed: assert empty should return the correct value when actual is not empty"
    exit 1
  fi
}

UnitTest_Assert_Not_Empty() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Empty "actual")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert not empty should not fail when actual is not empty"
    exit 1
  fi
}
UnitTest_Assert_Not_Empty_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Empty "")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert not empty should fail when actual is empty"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected '' to not be empty" ]; then
    echo "Test failed: assert not empty should return the correct value when actual is empty"
    exit 1
  fi
}


# File assertions

UnitTest_Assert_File_Exists() {
  #Given
  local actual=

  #When
  actual=$(Assert_File_Exists "$(Files_Path_Pipeliner)/README.md")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file exists should not fail when file exists"
    exit 1
  fi
}
UnitTest_Assert_File_Exists_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_File_Exists "$(Files_Path_Pipeliner)/DOESNOTEXIST")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file exists should fail when file does not exist"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/DOESNOTEXIST' to exist" ]; then
    echo "Test failed: assert file exists should return the correct value when file does not exist"
    exit 1
  fi

  #When
  actual=$(Assert_File_Exists "$(Files_Path_Pipeliner)/")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file exists should fail when file is a directory"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/' to exist" ]; then
    echo "Test failed: assert file exists should return the correct value when file is a directory"
    exit 1
  fi
}

UnitTest_Assert_Not_File_Exists() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_File_Exists "$(Files_Path_Pipeliner)/DOESNOTEXIST")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file not exists should not fail when file does not exist"
    exit 1
  fi

  #When
  actual=$(Assert_Not_File_Exists "$(Files_Path_Pipeliner)/")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file not exists should fail when file is a directory"
    exit 1
  fi
}
UnitTest_Assert_Not_File_Exists_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_File_Exists "$(Files_Path_Pipeliner)/README.md")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file not exists should fail when file exists"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/README.md' to not exist" ]; then
    echo "Test failed: assert file not exists should return the correct value when file exists"
    exit 1
  fi
}

UnitTest_Assert_File_Contains() {
  #Given
  local filename=$(Files_Path_Pipeliner)/README.md
  local contains="Pipeliner"
  local actual=

  #When
  actual=$(Assert_File_Contains "$filename" "$contains")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file contains should not fail when file contains expected"
    exit 1
  fi

  #Given
  local contains="P[a-z]pe.\+r "

  #When
  actual=$(Assert_File_Contains "$filename" "$contains")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file contains should not fail when file contains expected"
    exit 1
  fi
}
UnitTest_Assert_File_Contains_Fail() {
  #Given
  local filename=$(Files_Path_Pipeliner)/README.md
  local contains="DOESNOTEXIST"
  local actual=

  #When
  actual=$(Assert_File_Contains "$filename" "$contains")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file contains should fail when file does not contain expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/README.md' to contain 'DOESNOTEXIST'" ]; then
    echo "Test failed: assert file contains should return the correct value when file does not contain expected"
    exit
  fi

  #Given
  local filename=$(Files_Path_Pipeliner)/DOESNOTEXIST
  local contains="Pipeliner"

  #When
  actual=$(Assert_File_Contains "$filename" "$contains")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file contains should fail when file does not exist"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/DOESNOTEXIST' to exist" ]; then
    echo "Test failed: assert file contains should return the correct value when file does not exist"
    exit 1
  fi
}

UnitTest_Assert_File_Not_Contains() {
  #Given
  local filename=$(Files_Path_Pipeliner)/README.md
  local contains="DOESNOTEXIST"
  local actual=

  #When
  actual=$(Assert_File_Not_Contains "$filename" "$contains")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file not contains should not fail when file does not contain expected"
    exit 1
  fi

  #Given
  local contains="DOES[0-9]\+EXIST"

  #When
  actual=$(Assert_File_Not_Contains "$filename" "$contains")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert file not contains should not fail when file does not contain expected"
    exit 1
  fi
}
UnitTest_Assert_File_Not_Contains_Fail() {
  #Given
  local filename=$(Files_Path_Pipeliner)/README.md
  local contains="Pipeliner"
  local actual=

  #When
  actual=$(Assert_File_Not_Contains "$filename" "$contains")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file not contains should fail when file contains expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/README.md' to not contain 'Pipeliner'" ]; then
    echo "Test failed: assert file not contains should return the correct value when file contains expected"
    exit 1
  fi

  #Given
  local filename=$(Files_Path_Pipeliner)/DOESNOTEXIST
  local contains="Pipeliner"

  #When
  actual=$(Assert_File_Not_Contains "$filename" "$contains")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert file not contains should fail when file does not exist"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected file '$(Files_Path_Pipeliner)/DOESNOTEXIST' to exist" ]; then
    echo "Test failed: assert file not contains should return the correct value when file does not exist"
    exit 1
  fi
}


UnitTest_Assert_Directory_Exists() {
  #Given
  local actual=

  #When
  actual=$(Assert_Directory_Exists "$(Files_Path_Pipeliner)/")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert directory exists should not fail when directory exists"
    exit 1
  fi
}
UnitTest_Assert_Directory_Exists_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Directory_Exists "$(Files_Path_Pipeliner)/DOESNOTEXIST")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert directory exists should fail when directory does not exist"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected directory '$(Files_Path_Pipeliner)/DOESNOTEXIST' to exist" ]; then
    echo "Test failed: assert directory exists should return the correct value when directory does not exist"
    exit 1
  fi

  #When
  actual=$(Assert_Directory_Exists "$(Files_Path_Pipeliner)/README.md")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert directory exists should fail when directory is a file"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected directory '$(Files_Path_Pipeliner)/README.md' to exist" ]; then
    echo "Test failed: assert directory exists should return the correct value when directory is a file"
    exit 1
  fi
}

UnitTest_Assert_Not_Directory_Exists() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Directory_Exists "$(Files_Path_Pipeliner)/DOESNOTEXIST")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert directory not exists should not fail when directory does not exist"
    exit 1
  fi

  #When
  actual=$(Assert_Not_Directory_Exists "$(Files_Path_Pipeliner)/README.md")

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert directory not exists should fail when directory is a file"
    exit 1
  fi
}
UnitTest_Assert_Not_Directory_Exists_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Not_Directory_Exists "$(Files_Path_Pipeliner)/")

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert directory not exists should fail when directory exists"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected directory '$(Files_Path_Pipeliner)/' to not exist" ]; then
    echo "Test failed: assert directory not exists should return the correct value when directory exists"
    exit 1
  fi
}

UnitTest_Assert_Path_Owner() {
  #Given
  local actual=

  #When
  actual=$(Assert_Path_Owner "$(Files_Path_Pipeliner)/"  $(id -u))

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert path owner should not fail when path owner is expected"
    exit 1
  fi
}
UnitTest_Assert_Path_Owner_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Path_Owner "$(Files_Path_Pipeliner)/"  $(id -u)1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert path owner should fail when path owner is not expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected path '$(Files_Path_Pipeliner)/' to be owned by '$(id -u)1'" ]; then
    echo "Test failed: assert path owner should return the correct value when path owner is not expected"
    exit 1
  fi
}

UnitTest_Assert_Path_Group() {
  #Given
  local actual=

  #When
  actual=$(Assert_Path_Group "$(Files_Path_Pipeliner)/"  $(id -g))

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert path group should not fail when path group is expected"
    exit 1
  fi
}
UnitTest_Assert_Path_Group_Fail() {
  #Given
  local actual=

  #When
  actual=$(Assert_Path_Group "$(Files_Path_Pipeliner)/"  $(id -g)1)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert path group should fail when path group is not expected"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected path '$(Files_Path_Pipeliner)/' to be owned by '$(id -g)1'" ]; then
    echo "Test failed: assert path group should return the correct value when path group is not expected"
    exit 1
  fi
}


# Misc assertions

UnitTest_Assert_Function() {
  #Given
  local actual=

  #When
  actual=$(Assert_Function Assert_Equal)

  #Then
  if [ $? != 0 ]; then
    echo "Test failed: assert function should not fail when function exists"
    exit 1
  fi

  #When
  actual=$(Assert_Function NON_EXISTENT_FUNCTION)

  #Then
  if [ $? == 0 ]; then
    echo "Test failed: assert function should fail when function does not exist"
    exit 1
  fi
  if [ "$actual" != "Assert failed: expected function 'NON_EXISTENT_FUNCTION' to exist" ]; then
    echo "Test failed: assert function should return the correct value when function does not exist"
    exit 1
  fi
}
