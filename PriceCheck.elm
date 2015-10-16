import Signal
import Task exposing (Task, andThen)
import Http exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Debug exposing (..)
import AppStoreItem exposing (appView, App, getPriceTask)

apps : List App
apps = [ { id = 881270303, name = "", price = "" }
       , { id = 911006986, name = "", price = "" }
       , { id = 978524071, name = "", price = "" }
       , { id = 680366065, name = "", price = "" }
       , { id = 895869909, name = "", price = "" }
       , { id = 555916407, name = "", price = "" }
       , { id = 395680819, name = "", price = "" }
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
  sequenceAllTasks


allTasks : List (Task Http.Error (List App))
allTasks = List.map getPriceTask apps


sequenceAllTasks : Task Http.Error ()
sequenceAllTasks = Task.sequence allTasks `andThen` (List.concat >> sendToMailbox)


mainView : Model -> Html
mainView apps =
  ul []
    (List.map appView apps)


-- Run entry
main =
  Signal.map mainView contentMailbox.signal
