{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Semaphore.Project ( Project (..)
                         , showProject
                         , showProjects
                         ) where

import Data.Aeson as Json
import GHC.Generics
import Semaphore.Branch

data Project = Project { name     :: String
                       , owner    :: String
                       , branches :: [Branch]
                       } deriving (Generic)


instance Json.FromJSON Project
instance Json.ToJSON Project


showProject :: Project -> String
showProject project  = ownerProject ++ "\n" ++ showBranches (branches project)
  where ownerProject = owner project ++ "/" ++ name project


showProjects :: [Project] -> String
showProjects projects = unlines (map showProject projects)
