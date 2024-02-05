#!/bin/bash

Color__Output() {
  local color=$1
  local message=$2
  echo -en "$color$message\033[0m"
}

Color_Green() {
  Color__Output "\033[1;32m" "$1"
}

Color_Red() {
  Color__Output "\033[1;31m" "$1"
}

Color_Yellow() {
  Color__Output "\033[1;33m" "$1"
}

Color_Blue() {
  Color__Output "\033[1;34m" "$1"
}

Color_Purple() {
  Color__Output "\033[1;35m" "$1"
}

Color_Cyan() {
  Color__Output "\033[1;36m" "$1"
}

Color_White() {
  Color__Output "\033[1;37m" "$1"
}

Color_Gray() {
  Color__Output "\033[0;90m" "$1"
}

Color_Grey() {
  Color__Output "\033[1;90m" "$1"
}
