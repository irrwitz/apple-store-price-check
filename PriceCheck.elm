import Signal
import Graphics.Element exposing (Element, show)
import Task exposing (Task, andThen)
import Http exposing (..)
import Json.Decode as Json exposing (Decoder, (:=))
import Html exposing (..)
import Html.Attributes exposing (class)


-- Models
appIds : List Int
appIds = [ 881270303 -- xcom
         , 911006986 -- banner saga
         , 980307863 -- tales from deep space
         , 978524071 -- grim fandango
         , 680366065 -- device 6
         , 895869909 -- the sailor's dream
         , 555916407 --year walk
         , 395680819 -- av player
         ]


type alias App =
  { name  : String
  , price : String
  }


-- Update
contentMailbox : Signal.Mailbox (List App)
contentMailbox =
  Signal.mailbox [{ name = "", price = "0.0"}]


sendToMailbox : List App -> Task x ()
sendToMailbox content =
  Signal.send contentMailbox.address content


-- get the readme *and then* send the result to our mailbox
port fetchItem : Task Http.Error ()
port fetchItem =
  Http.get resultDecoder itemUrl `andThen` sendToMailbox


itemStoreUrl : Int -> String
itemStoreUrl appId =
  "https://itunes.apple.com/lookup?country=ch&id=" ++ (toString appId)


itemUrl : String
itemUrl =
  "https://itunes.apple.com/lookup?country=ch&id=881270303"


appDecoder : Decoder App
appDecoder =
  Json.object2 App
    ("trackName" := Json.string)
    ("formattedPrice" := Json.string)


resultDecoder : Decoder (List App)
resultDecoder =
  ("results" := Json.list appDecoder)


-- View
view : List App -> Html
view apps =
  ul [class "foo"]
    (List.map singleAppView apps)


singleAppView : App -> Html
singleAppView app =
  li [] [text (app.name ++ ", " ++ app.price)]


-- Run entry
main =
  Signal.map view contentMailbox.signal
