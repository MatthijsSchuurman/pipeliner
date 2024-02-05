#!/bin/bash

ORIGINALPWD=$PWD #store as soon as script get loaded
PACKAGEURL=https://tbd/pipeliner.zip

Install_Directory() {
  echo $ORIGINALPWD
}

Install_Directory_Temp() {
  echo $(Install_Directory)/.tmp
}

Install_Directory_Temp_Flush() {
  local directory=$(Install_Directory_Temp)

  if [ -d "$directory" ]; then
    rm -Rf "$directory" > /dev/null 2>&1
    if [ $? != 0 ]; then
      echo "Error: Unable to remove temporary directory $directory" >&2
      exit 1
    fi
  fi

  mkdir -p "$directory" > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Error: Unable to create temporary directory $directory" >&2
    exit 1
  fi
}

Install_Directory_Temp_Clear() {
  rm -Rf $(Install_Directory_Temp) > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Error: Unable to clear temporary directory $(Install_Directory_Temp)" >&2
    exit 1
  fi
}

Install_Is_Upgrade() {
  if [ -d $(Install_Directory)/.pipeliner ]; then
    return 0 #success
  fi

  return 1 #failure
}

Install_Download() {
  local url=$1

  if ! command -v wget > /dev/null; then
    echo "Error: wget not found" >&2
    exit 1
  fi

  local output=
  output=$(wget --no-clobber --content-disposition "$url" 2>&1)
  if [ $? != 0 ]; then
    echo "Error: Unable to download $url" >&2
    exit 1
  fi

  local filename=$(echo $output | grep "pipeliner-.*\.zip" | sed -E "s/.*(pipeliner-.*\.zip).*/\1/")
  echo "$filename"
}

Install_Extract() {
  local package=$1

  unzip "$package" -d "$(Install_Directory_Temp)" > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Error: Unable to extract $package" >&2
    exit 1
  fi
}

Install_Install() {
  if Install_Is_Upgrade; then
    rm -Rf "$(Install_Directory)/.pipeliner" "$(Install_Directory)/examples" > /dev/null 2>&1
  fi

  mv "$(Install_Directory_Temp)/.pipeliner" "$(Install_Directory_Temp)/examples" "$(Install_Directory)" > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "Error: Unable to move files from $(Install_Directory_Temp) to $(Install_Directory)" >&2
    exit 1
  fi

  if [ ! -d "$(Install_Directory)/.vscode" ]; then
    mkdir -p "$(Install_Directory)/.vscode" > /dev/null 2>&1
  fi
  for file in $(Install_Directory_Temp)/.vscode/*; do
    if [ ! -f "$(Install_Directory)/.vscode/$(basename $file)" ]; then
      mv "$file" "$(Install_Directory)/.vscode" > /dev/null 2>&1
    fi
  done

  return 0
}

Install_Validate() {
  .pipeliner/test.sh --type unit --include test/installed.sh
  if [ $? != 0 ]; then
    exit 1
  fi

  echo "For further validations, run: .pipeliner/test.sh"
}


#Main logic
if [ "$0" != "bash" -a "$0" != "${BASH_SOURCE[0]}" ]; then
  echo "Test mode"
else
  Install_Directory_Temp_Flush

  echo "Downloading $PACKAGEURL"
  package=$(Install_Download $PACKAGEURL)

  if Install_Is_Upgrade; then
    echo "Upgrading $(Install_Directory) with $package"
  else
    echo "Installing $package to $(Install_Directory)"
  fi
  Install_Extract $package
  Install_Install
  Install_Directory_Temp_Clear

  echo "Validating installation"
  Install_Validate

  echo
  echo "Installation complete, see .pipeliner/README.md for more information"
  echo
fi