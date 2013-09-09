module Main where

import Database.PostgreSQL.Simple
import Control.Monad
import Control.Applicative

printOnlies :: [Only Int] -> IO ()
printOnlies q =
  forM_ q $ \(Only i) ->
    print i

main = do
  conn <- connect defaultConnectInfo {
    connectDatabase = "haskell"
  }

  putStrLn "2 + 2"
  printOnlies =<< query_ conn "select 2 + 2"

  putStrLn "3 + 5"
  printOnlies =<< query conn "select ? + ?" (3 :: Int, 5 :: Int)

  putStrLn "Enter a word"
  word <- getLine
  execute conn "insert into words (word) values (?)" $ Only word
