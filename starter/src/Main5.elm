module Main5 exposing (main)

import Browser
import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (style, value)
import Html.Attributes exposing (placeholder)
import Time


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = Increment
    | Increment10 
    | Decrement
    | Reset
    | Change String


type alias Model =
  { counter: Int, content: String}

init: Model
init = {
  counter = 0,
  content = ""
  }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
          {model | counter = model.counter + 1}

        Increment10 ->
          {model | counter = model.counter + 10}

        Decrement ->
          {model | counter = model.counter - 1}

        Reset ->
          {model | counter = 0}

        Change newContent ->
          { model | content = newContent }




-- textNode: String -> Html Msg
-- textNode content =
--   div []
--       [ input [placeholder "Enter the message", value content, onInput Change] []
--       ] 

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.counter) ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ button [ onClick Reset ] [text "reset me"] ]
        , div [style "display" "block"] [ button [ onClick Increment10 ] [text "10+"] ]
        , input [ placeholder "Text to reverse", value model.content, onInput Change ] []
        , div [] [text ( (String.reverse model.content) ++ (String.fromInt (String.length model.content)) )]
        ]



