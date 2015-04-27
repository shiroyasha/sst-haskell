{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import qualified System.Environment
import qualified Network.HTTP.Conduit as Net
import Data.Aeson as Json
import GHC.Generics
import Control.Applicative

baseUrl :: [Char]
baseUrl = "https://s3.semaphoreci.com"

-- Each of the following section should probably be a seperate file
-- unfortunatelly I don't know how to achive that yet :(


--
-- Branches
--

data Branch = Branch { branch_name :: !String } deriving (Show, Generic)

showBranch :: Branch -> String
showBranch branch = "  - " ++ branch_name branch

showBranches :: [Branch] -> String
showBranches b = unlines (map showBranch b)

instance Json.FromJSON Branch
instance Json.ToJSON Branch

--
-- Projects
--

data Project = Project { name :: !String
                       , branches :: [Branch]
                       } deriving (Generic)

showProject :: Project -> String
showProject project   = name project ++ "\n" ++ showBranches (branches project)

showProjects :: [Project] -> String
showProjects projects = unlines (map showProject projects)

instance Json.FromJSON Project
instance Json.ToJSON Project


--
-- Api communication
--

type Path  = String
type Token = String

semaphore :: Token -> Path -> IO (Either String [Project])
semaphore token path =
  Json.eitherDecode <$> Net.simpleHttp (baseUrl ++ path ++ "?auth_token=" ++ token)


loadToken :: IO String
loadToken = head <$> System.Environment.getArgs


--
-- Main entry of the application
--

main :: IO ()
main = do
  token <- loadToken

  projects <- semaphore token "/api/v1/projects"

  case projects of
    Left err -> print err
    Right pr -> putStrLn $ showProjects pr
