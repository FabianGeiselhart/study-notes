module Prettify where

data Doc = Empty
         | Char Char
         | Text String
         | Line
         | Concat Doc Doc
         | Union Doc Doc
           deriving (Show, Eq)

punctuate :: Doc -> [Doc] -> [Doc]
punctuate p []     = []
punctuate p [d]    = [d]
punctuate p (d:ds) = (d <> p) : punctuate p ds

empty :: Doc
empty = Empty

char :: Char -> Doc
char = Char

text :: String -> Doc
text "" = Empty
text s  = Text s

double :: Double -> Doc
double d = text (show d)

line :: Doc
line = Line

(<>) :: Doc -> Doc -> Doc
Empty <> y = y
x <> Empty = x
x <> y     = x `Concat` y

hcat :: [Doc] -> Doc
hcat = fold (<>)

fold :: (Doc -> Doc -> Doc) -> [Doc] -> Doc
fold f = foldr f empty

fsep :: [Doc] -> Doc
fsep = fold (</>)

(</>) :: Doc -> Doc -> Doc
x </> y = x <> softline <> y

softline :: Doc
softline = group line

group :: Doc -> Doc
group x = flatten x `Union` x

flatten :: Doc -> Doc
flatten (x `Concat` y) = flatten x `Concat` flatten y
flatten Line           = Char ' '
flatten (x `Union` _)  = flatten x
flatten other          = other

compact :: Doc -> String
compact x = transform [x]
    where transform [] = ""
          transform (d:ds) =
            case d of
              Empty        -> transform ds
              Char c       -> c : transform ds
              Text s       -> s ++ transform ds
              Line         -> '\n' : transform ds
              a `Concat` b -> transform (a:b:ds)
              _ `Union` b  -> transform (b:ds)

pretty :: Int -> Doc -> String
pretty widht x = best 0 [x]
    where best col (d:ds) =
            case d of
              Empty        -> best col ds
              Char c       -> c : best (col + 1) ds
              Text s       -> s ++ best (col + length s) ds
              Line         -> '\n' : best 0 ds
              a `Concat` b -> best col (a:b:ds)
              a `Union` b  -> nicest col (best col (a:ds))
                                         (best col (b:ds))
          best _ _ = ""

          nicest col a b | (widht - least) `fits` a = a
                         | otherwise                = b
                         where least = min widht col

nest :: Int -> Doc -> Doc
nest indent x = go start [x]
    where go _ [] = Empty
          go lvl (d:ds) =
            case d of
              Empty        -> go lvl ds
              c@(Char cs)  -> c <> go sc (checkChar cs:ds)
              s@(Text ss)  -> s <> go lvl ds
              Line         -> Line <> Text (replicate sc ' ') <> go sc ds -- FIX
              Concat a b   -> go lvl (a:b:ds)
              Union a b    -> go lvl (b:ds)
            where sc = scanLine indent lvl ds

          start = scanLine indent 0 [x]
          checkChar c
           | c `elem` "{[(" = Line
           | otherwise      = Empty


scanLine :: Int -> Int -> [Doc] -> Int
scanLine steps indent x = go indent x
    where go lvl (d:ds) =
            case d of
              Char c       -> adjLvl lvl c
              Concat a b   -> go lvl (a:b:ds)
              Union a b    -> go lvl (b:ds)
              Line         -> lvl
              _            -> go lvl ds
          go lvl [] = lvl

          adjLvl lvl c
            | elem c incrementor = lvl + steps
            | elem c decrementor = lvl - steps
            | otherwise          = lvl

          incrementor = "{[("
          decrementor = "}])"

fits :: Int -> String -> Bool
w `fits` _ | w < 0 = False
_ `fits` ""        = True
_ `fits` ('\n':_)  = True
w `fits` (_:cs)    = (w - 1) `fits` cs
