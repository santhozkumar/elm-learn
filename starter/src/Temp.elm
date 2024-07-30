module Temp exposing (main)

import Browser
import Html exposing (Attribute, Html, div, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { celsiusInput : String
    , farenInput : String
    }


init : Model
init =
    { celsiusInput = ""
    , farenInput = ""
    }



-- UPDATE


type Msg
    = CelsiusChange String
    | FarenChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CelsiusChange newInput ->
            { model | celsiusInput = newInput }

        FarenChange newInput ->
            { model | farenInput = newInput }



-- VIEW


view : Model -> Html Msg
view model =
    let
        celsiusInput =
            model.celsiusInput

        farenInput =
            model.farenInput
    in
    div []
        [ case String.toFloat celsiusInput of
            Just celsius ->
                viewConverter celsiusInput CelsiusChange "blue" (String.fromFloat (celsius * 1.8 + 32))

            Nothing ->
                viewConverter celsiusInput CelsiusChange "red" "???"
        , case String.toFloat farenInput of
            Just celsius ->
                viewConverter farenInput FarenChange "blue" (String.fromFloat (celsius * 1.8 + 32))

            Nothing ->
                viewConverter farenInput FarenChange "red" "???"
        ]


viewConverter : String -> (String -> msg) -> String -> String -> Html msg
viewConverter userInput toMsg color equivalentTemp =
    span [style "display" "block"]
        [ input
            [ value userInput
            , onInput toMsg
            , style "width" "40px"
            , style "border-color" color
            ]
            []
        , text "°C = "
        , span [ style "color" color ] [ text equivalentTemp ]
        , text "°F"
        ]
