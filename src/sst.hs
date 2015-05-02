{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Text
import qualified Data.Text.IO as TIO

import Semaphore.Api
import Semaphore.Project
import Semaphore.Config
import Network.HTTP.Conduit
import Control.Exception

cantFindApiToken :: Text
cantFindApiToken = intercalate "\n" [
  "It seems you don't have a valid .sst/api_token file.",
  "Please create one by executing the following command:",
  "",
  "  echo '<api_token>' > ~/.sst/api_token"
  ]


connectionError :: Text
connectionError = intercalate "\n" [
  "The connection to Semaphore's API failed.",
  "Please make sure you have a working internet connection."
  ]

networkExceptionHandler :: HttpException -> IO (Either String a)
networkExceptionHandler _ = return $ Left (unpack connectionError)

showProjectTree :: String -> IO ()
showProjectTree apiToken = do
  apiDomain <- loadApiDomain

  projects  <- Semaphore.Api.getProjects apiDomain apiToken `catch` networkExceptionHandler

  case projects of
    Left err -> putStrLn err
    Right pr -> putStrLn $ showProjects pr


main :: IO ()
main = do
  apiToken <- loadApiToken

  case apiToken of
    Just token -> showProjectTree token
    Nothing    -> TIO.putStrLn cantFindApiToken
