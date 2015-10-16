module AppStoreItem where

import Http exposing (..)
import Html exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json exposing (Decoder, (:=))

type alias App =
  { id    : Int
  , name  : String
  , price : String
  }


getPriceTask : App -> Task Error (List App)
getPriceTask app =
  let
    url = "https://itunes.apple.com/lookup?country=ch&id=" ++ toString app.id
  in
    Http.get resultDecoder url

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
  Json.object3 App
    ("trackId" := Json.int)
    ("trackName" := Json.string)
    ("formattedPrice" := Json.string)


resultDecoder : Decoder (List App)
resultDecoder =
  ("results" := Json.list appDecoder)

