module Main where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow
import Database.PostgreSQL.Simple.ToField
import Data.Maybe
import Control.Monad
import Control.Applicative

data Dictionary = Dictionary { word :: Maybe String, definition :: Maybe String } deriving (Show)

instance FromRow Dictionary where
  fromRow = Dictionary <$> field <*> field

instance ToRow Dictionary where
  toRow d = [toField (word d), toField (definition d)]

main = do
  conn <- connect defaultConnectInfo { connectDatabase = "haskell" }

  mapM_ print =<< ( query_ conn "select word, definition from words" :: IO [Dictionary] )

  putStrLn "Enter a new word"
  word <- getLine
  putStrLn "What does it mean?"
  def <- getLine
  execute conn "insert into words (word, definition) values (?, ?)" $ Dictionary (Just word) (Just def)
