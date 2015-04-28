{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Data.Text
import qualified Data.Text.IO as TIO

import Semaphore.Api
import Semaphore.Project
import Semaphore.Config

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


showProjectTree :: String -> IO ()
showProjectTree apiToken = do
  apiDomain <- loadApiDomain

  projects  <- Semaphore.Api.getProjects apiDomain apiToken

  case projects of
    Left err -> TIO.putStrLn connectionError
    Right pr -> putStrLn $ showProjects pr


main :: IO ()
main = do
  apiToken <- loadApiToken

  case apiToken of
    Just token -> showProjectTree token
    Nothing    -> TIO.putStrLn cantFindApiToken
