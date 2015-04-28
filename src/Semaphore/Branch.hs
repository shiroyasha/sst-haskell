{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Semaphore.Branch ( Branch (..)
                        , showBranch
                        , showBranches
                        ) where

import Data.Aeson as Json
import GHC.Generics
import Semaphore.Colors

data Branch = Branch { branch_name :: String
                     , result      :: Maybe String
                     } deriving (Show, Generic)


instance Json.FromJSON Branch
instance Json.ToJSON Branch

drawTree :: [String] -> String
drawTree xs = unlines $ map ("├── "++) (init xs) ++ ["└── " ++ (last xs)]

branchStatus :: Maybe String -> String
branchStatus Nothing       = "Not Yet Built"
branchStatus (Just status) = colorizeBranchStatus status
  where colorizeBranchStatus = case status of
                                "failed" -> colorize Red
                                "passed" -> colorize Green
                                _        -> colorize Blue

showBranch :: Branch -> String
showBranch b = branchStatus (result b) ++ " :: " ++ branch_name b


showBranches :: [Branch] -> String
showBranches branches = drawTree $ map showBranch branches
