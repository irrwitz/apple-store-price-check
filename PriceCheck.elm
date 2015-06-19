import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (..)
import Html exposing (div, button, text)
import Html.Events exposing (onClick)
import StartApp

main =
  asText lookup

model = ""


lookup : Task Http.Error String
lookup =
    Http.getString "https://itunes.apple.com/lookup?id=422876559"

view model =
  div []
    [ asText model
    ]


