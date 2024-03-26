#!/bin/bash

source $(Files_Path_Pipeliner)/core/azdo.class.sh
source $(Files_Path_Pipeliner)/core/files.class.sh

UnitTest_AZDO_Agent_Latest() {
  #Given
  local actual=
  local exitCode=

  wget() { #mock to prevent rate limiting to ruin the test
    echo '{"tag_name": "v3.234.0"}'
  }

  #When
  actual=$(AZDO_Agent_Latest)
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Match "$actual" "^[0-9]+\.[0-9]+\.[0-9]+$"
}

UnitTest_AZDO_Agent_Download() {
  #Given
  local actual=
  local exitCode=
  local filename=

  wget() { #mock to prevent rate limiting to ruin the test
    echo "downloaded" > azdo-agent-v3.234.0.tar.gz
    return 0
  }
  AZDO_Agent_Latest() { #mock
    echo "3.234.0"
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Download > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Downloading AZDO Agent 3.234.0" ENDGROUP
  else
    Assert_Contains "$actual" group "Downloading AZDO Agent 3.234.0" endgroup
  fi

  filename=$(Variables_Get "azdoAgentFilename")
  Assert_Equal "$filename" "azdo-agent-v3.234.0.tar.gz"
  Assert_File_Exists "$filename"

  #Cleanup
  rm -f "$filename"
}

UnitTest_AZDO_Agent_Download_Fail() {
  #Given
  local actual=
  local exitCode=
  rm -f "azdo-agent-vinvalid.tar.gz"

  wget() { #mock to prevent rate limiting to ruin the test
    echo "failed"
    return 8
  }

  #When
  local logFile=$(Files_Temp_File test .log)
  AZDO_Agent_Download invalid > $logFile
  exitCode=$?
  actual=$(cat $logFile)
  rm $logFile

  #Then
  Assert_Equal $exitCode 8
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Downloading AZDO Agent invalid" ENDGROUP
    Assert_Contains "$actual" ERROR "Failed to download AZDO Agent invalid"
  else
    Assert_Contains "$actual" group "Downloading AZDO Agent invalid" endgroup
    Assert_Contains "$actual" error "Failed to download AZDO Agent invalid"
  fi

  Variables_Get "azdoAgentFilename" 2> /dev/null
  Assert_Equal $? 1
}

UnitTest_AZDO_Agent_Install() {
  #Given
  local actual=
  local exitCode=

  local filename=$(Files_Temp_File test .tar.gz)
  local directory=$(Files_Temp_Directory test)

  touch "$directory/config.sh"
  tar -czf "$filename" -C "$directory" .
  rm -Rf "$directory"

  #When
  actual=$(AZDO_Agent_Install "$filename" "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  Assert_Directory_Exists "$directory"
  Assert_File_Exists "$directory/config.sh"

  #Cleanup
  rm -Rf "$filename" "$directory"
}

UnitTest_AZDO_Agent_Install_Fail() {
  #Given
  local actual=
  local exitCode=

  local filename=invalid.tar.gz
  local directory=$(Files_Temp_Directory test)

  #When
  actual=$(AZDO_Agent_Install "$filename" "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "File not found: $filename"
  else
    Assert_Contains "$actual" error "File not found: $filename"
  fi
  Variables_Get "azdoAgentFilename" 2> /dev/null
  Assert_Equal $? 1

  #Cleanup
  rm -Rf "$directory"


  #Given
  filename=$(Files_Temp_File test .tar.gz)
  directory=$(Files_Temp_Directory test)

  #When
  actual=$(AZDO_Agent_Install "$filename" "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Directory already exists: $directory"
  else
    Assert_Contains "$actual" error "Directory already exists: $directory"
  fi

  #Cleanup
  rm -Rf "$filename" "$directory"


  #Given
  filename=$(Files_Temp_File test .tar.gz)
  directory=$(Files_Temp_Directory test)

  rm -Rf "$directory"

  #When
  actual=$(AZDO_Agent_Install "$filename" "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Invalid AZDO Agent file: $filename"
  else
    Assert_Contains "$actual" error "Invalid AZDO Agent file: $filename"
  fi

  #Cleanup
  rm -Rf "$filename" "$directory"
}

UnitTest_AZDO_Agent_Setup() {
  #Given
  local actual=
  local exitCode=

  local directory=$(Files_Temp_Directory test)
  local url="https://dev.azure.com/organization"
  local pat="personalAccessToken"
  local pool="pool1"
  local name="agent2"

  echo "echo url=$url
echo pat=$pat
echo pool=$pool
echo name=$name
" > "$directory/config.sh"
  chmod +x "$directory/config.sh"

  sudo() { #mock
    echo "sudo $@"
  }

  #When
  actual=$(AZDO_Agent_Setup "$directory" "$url" "$pat" "$pool" "$name")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 0
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" GROUP "Setting up AZDO Agent $directory" ENDGROUP
  else
    Assert_Contains "$actual" group "Setting up AZDO Agent $directory" endgroup
  fi

  Assert_Contains "$actual" "url=$url" "pat=$pat" "pool=$pool" "name=$name"
  Assert_Contains "$actual" "sudo ./svc.sh install" "sudo ./svc.sh start"

  #Cleanup
  rm -Rf "$directory"
}

UnitTest_AZDO_Agent_Setup_Fail() {
  #Given
  local actual=
  local exitCode=

  local directory=$(Files_Temp_Directory test)

  rm -Rf "$directory"

  #When
  actual=$(AZDO_Agent_Setup "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Directory not found: $directory"
  else
    Assert_Contains "$actual" error "Directory not found: $directory"
  fi


  #Given
  directory=$(Files_Temp_Directory test)

  #When
  actual=$(AZDO_Agent_Setup "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "File not found: $directory/config.sh"
  else
    Assert_Contains "$actual" error "File not found: $directory/config.sh"
  fi

  #Cleanup
  rm -Rf "$directory"
}

UnitTest_AZDO_Agent_Setup_Fail_Parameters() {
  #Given
  local actual=
  local exitCode=

  local directory=$(Files_Temp_Directory test)
  touch "$directory/config.sh"

  #When
  actual=$(AZDO_Agent_Setup "$directory")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "URL not specified"
  else
    Assert_Contains "$actual" error "URL not specified"
  fi


 #When
  actual=$(AZDO_Agent_Setup "$directory" "url")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "PAT not specified"
  else
    Assert_Contains "$actual" error "PAT not specified"
  fi


  #When
  actual=$(AZDO_Agent_Setup "$directory" "url" "pat")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Pool not specified"
  else
    Assert_Contains "$actual" error "Pool not specified"
  fi


  #When
  actual=$(AZDO_Agent_Setup "$directory" "url" "pat" "pool")
  exitCode=$?

  #Then
  Assert_Equal $exitCode 1
  if [ $(Environment_Platform) == "local" ]; then
    Assert_Contains "$actual" ERROR "Name not specified"
  else
    Assert_Contains "$actual" error "Name not specified"
  fi

  #Cleanup
  rm -Rf "$directory"
}

UnitTest_AZDO_URL_Trim() {
  #Given
  local actual=

  #When
  actual=$(AZDO_URL_Trim "https://dev.azure.com/organization")

  #Then
  Assert_Equal "$actual" "https://dev.azure.com/organization"


  #When
  actual=$(AZDO_URL_Trim "https://dev.azure.com/organization/project/")

  #Then
  Assert_Equal "$actual" "https://dev.azure.com/organization"


  #When
  actual=$(AZDO_URL_Trim "https://dev.azure.com/organization/project/_git/repo")

  #Then
  Assert_Equal "$actual" "https://dev.azure.com/organization"
}
