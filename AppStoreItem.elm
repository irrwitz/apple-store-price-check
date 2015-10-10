module AppStoreItem where

import Http exposing (..)
import Html exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json exposing (Decoder, (:=))

type alias App =
  { name  : String
  , price : String
  }


getPriceTask : String -> Task Error (List App)
getPriceTask appId = Http.get resultDecoder (itemStoreUrl appId)


itemStoreUrl : String -> String
itemStoreUrl appId =
  "https://itunes.apple.com/lookup?country=ch&id=" ++ appId


{--
  Html view
--}
appView : App -> Html
appView app =
  li [] [text (app.name ++ ", " ++ app.price)]

{--
  JSON Decoding
--}
appDecoder : Decoder App
appDecoder =
  Json.object2 App
    ("trackName" := Json.string)
    ("formattedPrice" := Json.string)


resultDecoder : Decoder (List App)
resultDecoder =
  ("results" := Json.list appDecoder)

