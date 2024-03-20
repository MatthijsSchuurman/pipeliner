#!/bin/bash

source $(Files_Path_Pipeliner)/haskell/haskell.class.sh

Haskell_Cabal_Build() {
  local workdir=$1

  Log_Info "Haskell Build"
  Haskell_Run "$workdir" "cabal update --builddir=dist/" "cabal build --builddir=dist/" "cabal install --builddir=dist/ --installdir=dist/ --overwrite-policy=always --install-method=copy"
}

Haskell_Cabal_Test() {
  local workdir=$1

  Log_Info "Haskell Test"
  Haskell_Run "$workdir" "cabal test --builddir=dist/ --test-log=test-report.txt | tee output.txt"
  local exitCode=$?

  local testReport=$(tail -n 2 "$workdir/output.txt" | head -n 1)
  rm -f "$workdir/output.txt"

  Haskell_Run "$workdir" "mv $testReport test-report.txt"
  return $exitCode
}

Haskell_Cabal_Lint() {
  local workdir=$1

  Log_Info "Haskell Lint"
  Haskell_Run "$workdir" "hlint --show --report=lint-report.html ."
}