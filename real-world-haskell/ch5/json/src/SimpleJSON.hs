module SimpleJSON
    (
      JValue(..)
    , getString
    , getInt
    , getDouble
    , getBool
    , getObject
    , getArray
    , isNull
    ) where

data JValue = JString String
            | JNumber Double
            | JBool Bool
            | JNull
            | JObject [(String, JValue)]
            | JArray [JValue]
              deriving (Eq, Ord, Show)

getString :: JValue -> Maybe String
getString (JString x) = Just x
getString _           = Nothing

getInt (JNumber x) = Just (truncate x)
getInt _           = Nothing

getDouble (JNumber x) = Just x
getDouble _           = Nothing

getBool (JBool x) = Just x
getBool _         = Nothing

getObject (JObject x) = Just x
getObject _           = Nothing

getArray (JArray x) = Just x
getArray _          = Nothing

isNull x = x == JNull
