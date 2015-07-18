import Signal
import Graphics.Element exposing (Element, show)
import Task exposing (Task, andThen)
import Http exposing (..)
import Json.Decode as Json


main : Signal Element
main =
  Signal.map show contentMailbox.signal


contentMailbox : Signal.Mailbox (String)
contentMailbox =
  Signal.mailbox ""


sendToMailbox : String -> Task x ()
sendToMailbox content =
  Signal.send contentMailbox.address content


-- get the readme *and then* send the result to our mailbox
port fetchItem : Task Http.Error ()
port fetchItem =
  Http.getString itemUrl `andThen` sendToMailbox


itemUrl : String
itemUrl =
  "https://itunes.apple.com/lookup?id=422876559"
