{-# LANGUAGE OverloadedStrings #-}

module Semaphore.Api ( getProjects ) where

import qualified Network.HTTP.Conduit as Net
import Data.Aeson as Json
import Control.Applicative

import Semaphore.Project

baseUrl :: String
baseUrl = "https://s3.semaphoreci.com"

type Path  = String
type Token = String

getProjects :: Token -> Path -> IO (Either String [Project])
getProjects token path = Json.eitherDecode <$> Net.simpleHttp url
  where url = baseUrl ++ path ++ "?auth_token=" ++ token
