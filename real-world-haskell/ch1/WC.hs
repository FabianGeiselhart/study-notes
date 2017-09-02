main = interact wordCound
    where wordCound input = show (length (lines input)) ++ "\n"
