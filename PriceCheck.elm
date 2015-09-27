import Signal
import Graphics.Element exposing (Element, show)
import Task exposing (Task, andThen)
import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Debug exposing (..)
import AppStoreItem exposing (..)

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
  getPriceTask "881270303" `andThen` sendToMailbox


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
