module Semaphore.Config (loadApiToken, loadApiDomain) where

import System.IO
import System.Directory
import Control.Applicative

defaultDomain :: String
defaultDomain = "https://s3.semaphoreci.com"

loadFileContent :: FilePath -> IO String
loadFileContent path = do
  handle <- openFile path ReadMode
  fileContent <- hGetContents handle

  return $ fileContent


loadFile :: FilePath -> IO (Maybe String)
loadFile path = do
  homePath <- getHomeDirectory

  let fullPath = homePath ++ "/" ++ path

  exists <- doesFileExist fullPath

  if exists
    then return <$> fmap (head . lines) (loadFileContent fullPath)
    else return $ Nothing


loadApiToken :: IO (Maybe String)
loadApiToken = loadFile "/.sst/api_token"


loadApiDomain :: IO String
loadApiDomain = do
  content <- loadFile "/.sst/api_domain"

  case content of
    Just domain -> return domain
    Nothing     -> return defaultDomain
