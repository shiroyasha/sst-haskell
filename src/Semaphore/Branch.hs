{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Semaphore.Branch ( Branch (..)
                        , showBranch
                        , showBranches
                        ) where

import Data.Aeson as Json
import GHC.Generics

data Branch = Branch { branch_name :: String
                     , result      :: Maybe String
                     } deriving (Show, Generic)


instance Json.FromJSON Branch
instance Json.ToJSON Branch


showBranch :: Branch -> String
showBranch branch = "  - " ++ branch_name branch ++ branchStatus (result branch)
  where branchStatus (Just status) = " :: " ++ status
        branchStatus Nothing       = " :: Not Yet Built"


showBranches :: [Branch] -> String
showBranches branches = unlines (map showBranch branches)
