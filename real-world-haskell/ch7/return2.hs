import Data.Char (toUpper)

isYes :: String -> Bool
isYes inp = (toUpper . head $ inp) == 'Y'

isGreen :: IO Bool
isGreen = do
    putStrLn "Is green your favorite color?"
    inpStr <- getLine
    return (isYes inpStr)
