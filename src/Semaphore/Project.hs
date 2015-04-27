{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Semaphore.Project ( Project (..)
                         , showProject
                         , showProjects
                         ) where

import Data.Aeson as Json
import GHC.Generics
import Semaphore.Branch
import Semaphore.Colors

data Project = Project { name     :: String
                       , owner    :: String
                       , branches :: [Branch]
                       } deriving (Generic)


instance Json.FromJSON Project
instance Json.ToJSON Project


showProject :: Project -> String
showProject p = ownerProject ++ "\n" ++ showBranches (branches p)
  where ownerProject = colorize Yellow $ owner p ++ "/" ++ name p


showProjects :: [Project] -> String
showProjects projects = unlines (map showProject projects)
