import Signal
import Graphics.Element exposing (Element, show)
import Task exposing (Task, andThen)
import Http exposing (..)
import Json.Decode as Json exposing (Decoder, (:=))
import Html exposing (..)
import Html.Attributes exposing (class)

-- Inspiration https://gist.github.com/TheSeamau5/1dc5597a2e3b7ae5f33e

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


type alias Model =
  List App


initialModel : Model
initialModel = []


-- Update
contentMailbox : Signal.Mailbox (List App)
contentMailbox =
  Signal.mailbox []


sendToMailbox : List App -> Task x ()
sendToMailbox content =
  Signal.send contentMailbox.address content


port fetchItem : Task Http.Error ()
port fetchItem =
  Http.get resultDecoder itemUrl `andThen` sendToMailbox


createTasks : String -> Task Http.Error ()
createTasks url =
  Http.get resultDecoder url `andThen` sendToMailbox


urls : List String
urls =
  List.map itemStoreUrl appIds


itemStoreUrl : Int -> String
itemStoreUrl appId =
  "https://itunes.apple.com/lookup?country=ch&id=" ++ (toString appId)


itemUrl : String
itemUrl =
  "https://itunes.apple.com/lookup?country=ch&id=881270303"


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


-- View
singleAppView : App -> Html
singleAppView app =
  li [] [text (app.name ++ ", " ++ app.price)]


view : Model -> Html
view apps =
  ul [class "foo"]
    (List.map singleAppView apps)


-- Run entry
main =
  Signal.map view contentMailbox.signal
