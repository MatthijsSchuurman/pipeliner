module Main where

import SayHelloTest
import OtherFunctionalityTest
import Test.Tasty

-- Combine test modules into a test suite
tests :: TestTree
tests = testGroup "All Tests" [sayHelloTest, otherFunctionalityTest]

-- Run the test suite
main :: IO ()
main = defaultMain tests
