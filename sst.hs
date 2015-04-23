{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import qualified System.Environment
import qualified Network.HTTP.Conduit as Net
import qualified Data.ByteString.Lazy.Char8 as BS
import Data.Aeson as Json
import qualified Data.Vector
import qualified Data.HashMap.Strict
import Data.Maybe
import Data.Typeable
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import GHC.Generics
import Control.Monad
import Control.Applicative

baseUrl = "https://s3.semaphoreci.com"

-- Each of the following section should probably be a seperate file
-- unfortunatelly I don't know how to achive that yet :(


--
-- Branches
--

data Branch = Branch { branch_name :: !String } deriving (Show, Generic)

showBranch :: Branch -> String
showBranch branch = "  - " ++ (branch_name branch)

showBranches :: [Branch] -> String
showBranches branches = unlines (map showBranch branches)

instance Json.FromJSON Branch
instance Json.ToJSON Branch

--
-- Projects
--

data Project = Project { name :: !String
                       , branches :: [Branch]
                       } deriving (Show, Generic)

showProject :: Project -> String
showProject project = (name project) ++ "\n" ++ (showBranches (branches project))

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
semaphore token path = do
  Json.eitherDecode <$> Net.simpleHttp (baseUrl ++ path ++ "?auth_token=" ++ token)


loadToken :: IO String
loadToken = do
  args <- System.Environment.getArgs 

  return (args !! 0)


--
-- Main entry of the application
--

main = do
  token <- loadToken

  projects <- semaphore token "/api/v1/projects"

  case projects of
    Left error -> print $ error
    Right pr   -> putStrLn $ showProjects pr
