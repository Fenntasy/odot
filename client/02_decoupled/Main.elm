module Main exposing (..)

import Html exposing (button, div, form, h1, input, li, ul, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import TodoModule as Todo exposing (Todo)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
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
    ( { todoList = [], newTodo = "" }, Todo.fetchTodoList Update )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTodo ->
            ( { model | newTodo = "" }, Todo.addTodo Update model.newTodo )

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
        , ul [] (List.map (\todo -> li [] [ text todo.name ]) model.todoList)
        , form [ onSubmit AddTodo ]
            [ input [ onInput NewTodo, value model.newTodo ] []
            , button [ type_ "submit" ] [ text "Add" ]
            ]
        ]
