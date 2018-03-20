module Main exposing (..)

import Html exposing (button, div, form, h1, input, li, ul, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import Json.Decode
import Json.Encode


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Todo =
    { id : String
    , done : Bool
    , name : String
    }


type alias Model =
    { todoList : List Todo
    , newTodo : String
    }


type Msg
    = AddTodo
    | Update (Result Http.Error (List Todo))
    | NewTodo String


init : ( Model, Cmd Msg )
init =
    ( { todoList = [], newTodo = "" }, fetchTodoList )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTodo ->
            ( { model | newTodo = "" }, addTodo model.newTodo )

        Update (Ok todoList) ->
            ( { model | todoList = todoList }, Cmd.none )

        Update (Err _) ->
            ( model, Cmd.none )

        NewTodo name ->
            ( { model | newTodo = name }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Todos" ]
        , ul []
            (model.todoList
                |> List.map
                    (\todo ->
                        li [] [ text todo.name ]
                    )
            )
        , form [ onSubmit AddTodo ]
            [ input [ onInput NewTodo, value model.newTodo ] []
            , button [ type_ "submit" ] [ text "Add" ]
            ]
        ]


fetchTodoList : Cmd Msg
fetchTodoList =
    Http.get "http://localhost:4000/lists/lillefp" todoListDecoder
        |> Http.send Update


addTodo : String -> Cmd Msg
addTodo name =
    Http.post "http://localhost:4000/lists/lillefp"
        (Http.jsonBody (todoEncoder name))
        todoListDecoder
        |> Http.send Update


todoDecoder : Json.Decode.Decoder Todo
todoDecoder =
    Json.Decode.map3 Todo
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "done" Json.Decode.bool)
        (Json.Decode.field "name" Json.Decode.string)


todoListDecoder : Json.Decode.Decoder (List Todo)
todoListDecoder =
    Json.Decode.field "list"
        (Json.Decode.list todoDecoder)


todoEncoder : String -> Json.Encode.Value
todoEncoder name =
    (Json.Encode.object
        [ ( "name", Json.Encode.string name )
        ]
    )
