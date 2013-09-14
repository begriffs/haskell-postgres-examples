module Main where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Data.Maybe
import Control.Monad
import Control.Applicative

data Dictionary = Dictionary { word :: Maybe String, definition :: Maybe String } deriving (Show)

instance FromRow Dictionary where
  fromRow = Dictionary <$> field <*> field

main = do
  conn <- connect defaultConnectInfo { connectDatabase = "haskell" }

  mapM_ print =<< ( query_ conn "select word, definition from words" :: IO [Dictionary] )
