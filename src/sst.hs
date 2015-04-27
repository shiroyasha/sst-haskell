module Main (main) where

import System.Environment
import Control.Applicative

import Semaphore.Api
import Semaphore.Project

loadToken :: IO String
loadToken = head <$> System.Environment.getArgs

main :: IO ()
main = do
  apiToken <- loadToken
  projects <- Semaphore.Api.getProjects apiToken "/api/v1/projects"

  case projects of
    Left err -> print err
    Right pr -> putStrLn $ showProjects pr
