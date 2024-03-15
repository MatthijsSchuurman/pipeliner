module HelloWorld (sayHello) where

sayHello :: IO Int
sayHello = do
  putStrLn "Hello, World!"
  return 0