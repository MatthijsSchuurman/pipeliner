module Main where

import HelloWorld

main :: IO ()
main = do
  result <- sayHello
  putStrLn $ "Returned value: " ++ show result
