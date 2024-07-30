module Quote exposing (main)

import Browser
import Html exposing (Html, div, text, p, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Platform.Cmd as Cmd

import Svg exposing (circle, rect, svg)
import Svg.Attributes exposing (cx, cy, height, rx, ry, viewBox, width, x, y, r)

import Json.Decode exposing (Decoder, map4, map3, field, int, string)



-- MAIN

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success Quote


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none




type alias Author =
    { name : String
    , origin : String
    , age : Int
    }


type alias Quote =
    { source : String
    , author : Author
    , quote : String
    , year : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomQuote )


type Msg
    = GotQuote (Result Http.Error Quote)
    | MorePlease


getRandomQuote : Cmd Msg
getRandomQuote =
    Http.get
        { url = "https://elm-lang.org/api/random-quotes/v2"
        , expect = Http.expectJson GotQuote quoteDecoder
        }


quoteDecoder: Decoder Quote
quoteDecoder = 
  map4 Quote 
    (field "source" string)
    (field "author" authorDecoder)
    (field "quote" string)
    (field "year" int)


authorDecoder: Decoder Author
authorDecoder = 
  map3 Author 
    (field "name" string)
    (field "origin" string)
    (field "age" int)



view: Model -> Html Msg
view model = 
  case model of
    Loading ->
      div []
        [ loadingSVG ]

      -- [ p [style "font-size" "100px"]
      --   [text "Loading the page.."]
      -- ]
    Failure -> 
      div []
      [ p [style "font-size" "100px"]
        [text "Failed to pull the quote"]
      ]
    Success data -> 
      div []
      [ p [style "font-size" "10px"]
        [text data.source]
      , p [style "font-size" "10px"]
        [text data.author.name]
      , p [style "font-size" "10px"]
        [text data.quote]
      ,div [] [
        button [ onClick MorePlease] [text "Fetch More"]]
      ]



update:  Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    GotQuote result -> 
      case result of
          Ok quote ->
            (Success quote, Cmd.none)
          Err _ ->
            (Failure, Cmd.none)

    MorePlease ->
      (Loading, getRandomQuote)


loadingSVG: Html msg
loadingSVG =
  svg
    [ width "120"
    , height "120"
    , viewBox "0 0 120 120"
    ]
    [ rect
        [ x "10"
        , y "10"
        , width "100"
        , height "100"
        , rx "15"
        , ry "15"
        ]
        []
    , circle
        [ cx "50"
        , cy "50"
        , r "50"
        ]
        []
    ]
