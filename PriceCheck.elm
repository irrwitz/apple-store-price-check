import Signal
import Graphics.Element exposing (Element, show)
import Task exposing (Task, andThen)
import Http exposing (..)
import Json.Decode as Json exposing ((:=))


main : Signal Element
main =
  Signal.map show contentMailbox.signal


contentMailbox : Signal.Mailbox (List String)
contentMailbox =
  Signal.mailbox [""]


sendToMailbox : List String -> Task x ()
sendToMailbox content =
  Signal.send contentMailbox.address content


-- get the readme *and then* send the result to our mailbox
port fetchItem : Task Http.Error ()
port fetchItem =
  Http.get app itemUrl `andThen` sendToMailbox


itemUrl : String
itemUrl =
  "https://itunes.apple.com/lookup?id=881270303"


app : Json.Decoder (List String)
app =
  let place =
        Json.object2 (\name price -> name ++ ": " ++ price)
          ("trackName" := Json.string)
          ("formattedPrice" := Json.string)
  in
      "results" := Json.list place
