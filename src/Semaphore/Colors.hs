module Semaphore.Colors ( Color (..)
                        , colorize
                        ) where

data Color = Black  
           | Red    
           | Yellow 
           | Green  
           | Blue 

colorize :: Color -> String -> String
colorize Black  s = "\ESC[30m" ++ s ++ "\ESC[0m"
colorize Red    s = "\ESC[31m" ++ s ++ "\ESC[0m"
colorize Green  s = "\ESC[32m" ++ s ++ "\ESC[0m"
colorize Yellow s = "\ESC[33m" ++ s ++ "\ESC[0m"
colorize Blue   s = "\ESC[34m" ++ s ++ "\ESC[0m"
