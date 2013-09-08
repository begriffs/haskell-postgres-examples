module Main where

import Database.PostgreSQL.Simple
import Control.Monad
import Control.Applicative

printOnlies :: (Show a) => [Only a] -> IO ()
printOnlies q =
  forM_ q $ \(Only i) ->
    putStrLn $ show i

main = do
  conn <- connect defaultConnectInfo

  putStrLn "2 + 2"
  printOnlies =<< (query_ conn "select 2 + 2" :: IO [Only Int])

  putStrLn "3 + 5"
  printOnlies =<< (query conn "select ? + ?" (3 :: Int, 5 :: Int) :: IO [Only Int])

  putStrLn "Enter a word"
  word <- getLine :: IO String
  (query conn "insert into words (word) values (?)" $ Only word) :: IO [Only Int]
  return ()
