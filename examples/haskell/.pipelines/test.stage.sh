#!/bin/bash

Haskell_Pipelines_Stage_Test() {
  local app=$1

  Haskell_Cabal_Test $app
  #Haskell_Cabal_Lint $app
}