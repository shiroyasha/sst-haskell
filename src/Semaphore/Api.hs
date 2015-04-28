{-# LANGUAGE OverloadedStrings #-}

module Semaphore.Api ( getProjects ) where

import Data.Aeson as Json
import Network.HTTP.Conduit
import Control.Applicative

import Semaphore.Project

type ApiToken  = String
type ApiDomain = String

constructUrl :: ApiDomain -> ApiToken -> String -> String
constructUrl domain path token = domain ++ path ++ "?auth_token=" ++ token

getProjects :: ApiDomain -> ApiToken -> IO (Either String [Project])
getProjects domain token = Json.eitherDecode <$>
  simpleHttp (constructUrl domain "/api/v1/projects" token)
