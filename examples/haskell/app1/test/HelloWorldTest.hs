module HelloWorldTest (tests) where

import Test.Tasty
import Test.Tasty.HUnit
import HelloWorld

tests :: TestTree
tests = testGroup "HelloWorld Tests"
  [ testCase "sayHello returns 0" $
      HelloWorld.sayHello >>= (@?= 0)
  ]
