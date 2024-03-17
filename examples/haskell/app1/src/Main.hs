module Main where

import HelloWorld

main :: IO ()
main = do
  result <- HelloWorld.sayHello
  putStrLn $ "Returned value: " ++ show result
