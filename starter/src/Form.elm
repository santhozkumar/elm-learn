module Form exposing (main)

import Browser
import Html exposing (Html, div, input, text)
import Html.Events exposing (onInput)
import Html.Attributes exposing (type_, placeholder, value, style)
import Char exposing (isDigit, isLower, isUpper)

main =
  Browser.sandbox { init=init, view=view, update=update}


type Msg 
  = Name String
  | Password String
  | PasswordAgain String

type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init : Model
init =
    Model "" "" ""


update: Msg -> Model -> Model
update msg model = 
  case msg of
    Name name -> 
      { model | name = name }
    Password password -> 
      { model | password = password }
    PasswordAgain passwordagian -> 
      { model | passwordAgain = passwordagian }


viewInput: String -> String -> String -> (String -> msg) -> Html msg
viewInput t ph v toMsg = 
  div[] 
  [ input [ type_ t, placeholder ph, value v, onInput toMsg] []
  ]


view: Model -> Html Msg
view model = 
  div []
  [ viewInput "text" "Name" model.name Name 
  , viewInput "password" "Password" model.password Password 
  , viewInput "password" "PasswordAgain" model.passwordAgain PasswordAgain 
  , viewValidation model]


viewValidation: Model -> Html Msg
viewValidation model = 
  -- if (isEmpty model.password) || (isEmpty model.passwordAgain) then 
  --   div [style "color" "green"] [text "Password is empty"]
  -- else
  --   div [] [text ""]
  let
      password = model.password
  in

  if model.password == model.passwordAgain then
    if String.length model.passwordAgain <= 3 then 
      div [style "color" "blue"] [text "Password too short"]
    else if (
        String.any isDigit password
        && String.any isLower password
        && String.any isUpper password
        ) then
      div [style "color" "green"] [text "Ok"]
    else
      div [style "color" "brown"] [text "must have upper, lower, numeric and special characters"]
  else 
    div [style "color" "red"] [text "Password do not match"]
