module SimpleTodo exposing (..)

import Html exposing (button, div, form, h1, input, li, ul, text)
import Html.Attributes exposing (type_, value)
import Html.Events exposing (onInput, onSubmit)
import Http
import TodoComponent as Todo exposing (Todo, TodoState)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }


type alias Model =
    { todoState : TodoState
    , newTodo : String
    }


type Msg
    = AddTodo
    | Update (Result Http.Error TodoState)
    | NewTodo String


init : ( Model, Cmd Msg )
init =
    let
        model =
            { todoState = Todo.init, newTodo = "" }
    in
        ( model
        , Todo.fetchTodoList model.todoState Update
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddTodo ->
            ( { model | newTodo = "" }, Todo.addTodo model.todoState Update model.newTodo )

        Update (Ok todoState) ->
            ( { model | todoState = todoState }, Cmd.none )

        Update (Err _) ->
            ( model, Cmd.none )

        NewTodo name ->
            ( { model | newTodo = name }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Todos" ]
        , ul []
            (model.todoState
                |> Todo.getTodoList
                |> List.map (\todo -> li [] [ text todo.name ])
            )
        , form [ onSubmit AddTodo ]
            [ input [ onInput NewTodo, value model.newTodo ] []
            , button [ type_ "submit" ] [ text "Add" ]
            ]
        ]
