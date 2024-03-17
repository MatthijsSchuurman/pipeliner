import HelloWorld
import System.Exit (exitSuccess, exitFailure)

main :: IO ()
main = do
  HelloWorld.sayHello
  return ()