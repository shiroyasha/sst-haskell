{-# LANGUAGE OverloadedStrings #-}

module Semaphore.Api ( getProjects ) where

import Data.Aeson as Json
import Network.HTTP.Conduit
import Control.Applicative

import Semaphore.Project

baseUrl :: String
baseUrl = "https://s3.semaphoreci.com"

type ApiToken = String

constructUrl :: ApiToken -> String -> String
constructUrl token path = baseUrl ++ path ++ "?auth_token=" ++ token

getProjects :: ApiToken -> IO (Either String [Project])
getProjects token = Json.eitherDecode <$>
  simpleHttp (constructUrl token "/api/v1/projects")
