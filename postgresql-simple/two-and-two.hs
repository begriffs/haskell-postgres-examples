 module Main where

 import Database.PostgreSQL.Simple
 import Control.Monad

 main = do
   conn <- connect defaultConnectInfo
   xs   <- query_ conn "select 2 + 2"
   forM_ xs $ \(Only i) ->
     putStrLn $ show (i :: Int)
