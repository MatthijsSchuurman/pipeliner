#!/bin/bash

source $(Files_Path_Pipeliner)/haskell/haskell.class.sh

Haskell_Cabal_Build() {
  local workdir=$1

  Log_Info "Haskell Build"
  Haskell_Run "$workdir" "cabal update" "cabal build"
}

Haskell_Cabal_Test() {
  local workdir=$1

  Log_Info "Haskell Test"
  Haskell_Run "$workdir" "cabal test --log=/path/to/test-report.xml"
}

Haskell_Cabal_Lint() {
  local workdir=$1

  Log_Info "Haskell Lint"
  Haskell_Run "$workdir" "hlint --report=lint-report.json"
}