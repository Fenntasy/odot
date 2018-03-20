module MultipleTodo exposing (..)

import Html exposing (button, div, form, h1, input, li, ul, text)
import Html.Attributes exposing (classList, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import SelectList exposing (SelectList)
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
    , todoLists : SelectList String
    , newTodo : String
    , newList : String
    }


type Msg
    = AddList
    | AddTodo
    | ChangeList String
    | Update (Result Http.Error TodoState)
    | NewList String
    | NewTodo String


init : ( Model, Cmd Msg )
init =
    let
        defaultList =
            "default"

        model =
            { todoState = Todo.switchList Todo.init defaultList
            , todoLists = SelectList.singleton defaultList
            , newTodo = ""
            , newList = ""
            }
    in
        ( model
        , Todo.fetchTodoList model.todoState Update
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddList ->
            let
                newTodoState =
                    Todo.switchList model.todoState model.newList
            in
                ( { model
                    | newList = ""
                    , todoState = newTodoState
                    , todoLists =
                        model.todoLists
                            |> SelectList.append [ model.newList ]
                            |> SelectList.select ((==) model.newList)
                  }
                , Todo.fetchTodoList newTodoState Update
                )

        AddTodo ->
            ( { model | newTodo = "" }, Todo.addTodo model.todoState Update model.newTodo )

        ChangeList list ->
            let
                newTodoState =
                    Todo.switchList model.todoState list
            in
                ( { model
                    | todoState = newTodoState
                    , todoLists = SelectList.select ((==) list) model.todoLists
                  }
                , Todo.fetchTodoList newTodoState Update
                )

        Update (Ok todoState) ->
            ( { model | todoState = todoState }, Cmd.none )

        Update (Err _) ->
            ( model, Cmd.none )

        NewList name ->
            ( { model | newList = name }, Cmd.none )

        NewTodo name ->
            ( { model | newTodo = name }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div []
        [ h1 [] [ text "Todos" ]
        , ul []
            (model.todoLists
                |> SelectList.mapBy displayList
                |> SelectList.toList
            )
        , form [ onSubmit AddList ]
            [ input [ onInput NewList, value model.newList ] []
            , button [ type_ "submit" ] [ text "Add List" ]
            ]
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


displayList : SelectList.Position -> String -> Html.Html Msg
displayList position list =
    li
        [ classList [ ( "active", position == SelectList.Selected ) ]
        , onClick (ChangeList list)
        ]
        [ text list ]
