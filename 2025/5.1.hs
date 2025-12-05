module Main where
import System.IO (openFile, IOMode(ReadMode), hGetContents)
import Text.Read (readMaybe)

splitAtDoubleLn :: String -> (String, String)
splitAtDoubleLn [] = ([], [])
splitAtDoubleLn [c] = ([c], [])
splitAtDoubleLn (c:c2:cs)
  | c == '\n' && c2 == '\n' = ([], cs)
  | otherwise = let
      (before, after) = splitAtDoubleLn (c2:cs)
      in
        (c:before, after)

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


toRange :: (String, String) -> (Int, Int)
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

inRange :: Int -> (Int, Int) -> Bool
inRange a (b, c) =  b <= a && a <= c

inRanges :: [(Int, Int)] -> Int -> Bool
inRanges [] _ = False
inRanges [r] a = inRange a r
inRanges (r:rs) a = inRange a r || inRanges rs a


readInput :: String -> ([(Int,Int)], [Int])
readInput s = let
  (fresh_ranges_str, available_ids_str) = splitAtDoubleLn s
  fresh_ranges = map (toRange . firstTwo . (splitAtChar '-')) (words fresh_ranges_str)
  available_ids = map toInt (words available_ids_str)
  in
    (fresh_ranges, available_ids)

process s = let
  (ranges, ids) = readInput s
  in
  length $ filter (inRanges ranges) ids



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
