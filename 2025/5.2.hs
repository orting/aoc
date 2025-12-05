module Main where
import System.IO (openFile, IOMode(ReadMode), hGetContents)
import Data.List (sort)
import Text.Read (readMaybe)

type Range = (Int, Int)

takeUntilDoubleLn :: String -> String
takeUntiltDoubleLn [] = []
takeUntilDoubleLn [c] = [c]
takeUntilDoubleLn (c:c2:cs)
  | c == '\n' && c2 == '\n' = []
  | otherwise = c : takeUntilDoubleLn (c2:cs)

splitAtChar :: Char -> String -> [String]
splitAtChar _ [] = []
splitAtChar c (c1:cs)
  | c == c1 = splitAtChar c cs
  | otherwise = let
      (before, after) = splitAtChar2 c cs
      in
        (c1:before):(splitAtChar c after)

splitAtChar2 :: Char -> String -> (String, String)
splitAtChar2 _ [] = ([], [])
splitAtChar2 c (c1:cs)
  | c == c1 = ([], cs)
  | otherwise = let
      (before, after) = splitAtChar2 c cs
      in
        (c1:before, after)

firstTwo :: [String] -> (String,String)
firstTwo [] = ("", "")
firstTwo [s]  = (s, "")
firstTwo (s:t:_) = (s,t)

toRange :: (String, String) -> Range
toRange (s, t) = let
  x = case readMaybe s :: Maybe Int of
        Nothing -> -1
        Just n -> n
  y = case readMaybe t :: Maybe Int of
        Nothing -> -1
        Just n -> n
  in
    (x, y)

toInt :: String -> Int
toInt s = case readMaybe s :: Maybe Int of
  Nothing -> -1
  Just n -> n

toRange :: (String, String) -> Range
toRange (s, t) = (toInt s, toInt t)

mergeRanges :: [Range] -> [Range]
mergeRanges [] = []
mergeRanges [r] = [r]
mergeRanges ((a,b):(c,d):rs)
  | b >= c = mergeRanges ((a, max b d) : rs)
  | otherwise = (a,b) : (mergeRanges ((c,d) : rs))

rangeSize :: Range -> Int
rangeSize (a, b) = 1 + b - a -- (a, a) has size 1

process s = let
  ranges = readInput s
  in
    sum $ map rangeSize $ mergeRanges $ sort ranges

sample_path = "inputs/5.sample.txt"
real_path = "inputs/5.txt"
main = do
  handle <- openFile sample_path ReadMode
  lines <- hGetContents handle
  print "Sample"
  print $ process lines
  handle <- openFile real_path ReadMode
  lines <- hGetContents handle
  print "Real"
  print $ process lines
