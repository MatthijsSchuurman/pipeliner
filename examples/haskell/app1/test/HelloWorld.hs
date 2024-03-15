module SayHelloTest where

import HelloWorld (sayHello)
import Test.Tasty
import Test.Tasty.HUnit

sayHelloTest :: TestTree
sayHelloTest = testCase "sayHello returns 0" $ do
    result <- sayHello
    assertEqual "sayHello returns 0" 0 result
