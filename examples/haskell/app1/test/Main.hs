import HelloWorldTest
import Test.Tasty

-- Combine test modules into a test suite
testTree :: TestTree
testTree = testGroup "All Tests" [HelloWorldTest.tests]

-- Run the test suite
main :: IO ()
main = defaultMain testTree