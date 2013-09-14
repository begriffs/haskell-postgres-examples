module Main where

import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import Data.Maybe
import Control.Monad
import Control.Applicative

data Dictionary = Dictionary { word :: Maybe String, definition :: Maybe String }

instance FromRow Dictionary where
  fromRow = Dictionary <$> field <*> field

instance Show Dictionary where
  show d = (showOrNull $ word d) ++ " means " ++ (showOrNull $ definition d) where
    showOrNull = fromMaybe "null"

main = do
  conn <- connect defaultConnectInfo { connectDatabase = "haskell" }

  mapM_ print =<< ( query_ conn "select word, definition from words" :: IO [Dictionary] )
