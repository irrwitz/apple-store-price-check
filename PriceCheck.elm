import Http
import Json.Decode as Json exposing ((:=))
import Html exposing (Html, div, button, text)
import Html.Events exposing (onClick)
import Task exposing (Task, andThen)
import Markdown


--main : Signal Html
main =
  Signal.map Markdown.toHtml readme.signal


-- set up mailbox
--   the signal is piped directly to main
--   the address lets us update the signal
readme : Signal.Mailbox String
readme =
  Signal.mailbox ""


-- send some markdown to our readme mailbox
report : String -> Task x ()
report markdown =
  Signal.send readme.address markdown


-- get the readme *and then* send the result to our mailbox
port fetchReadme : Task Http.Error ()
port fetchReadme =
  Http.getString readmeUrl `andThen` report


-- the URL of the README.md that we desire
readmeUrl : String
readmeUrl =
  "http://package.elm-lang.org/packages/elm-lang/core/latest/README.md"


lookup : Task Http.Error String
lookup =
    Http.getString "https://itunes.apple.com/lookup?id=422876559"


