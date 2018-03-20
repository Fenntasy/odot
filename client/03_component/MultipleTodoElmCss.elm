module MultipleTodoElmCss exposing (..)

import Css exposing (..)
import Css.Colors
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, placeholder, src, type_, value)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Http
import SelectList exposing (SelectList)
import SelectList exposing (SelectList)
import TodoComponent as Todo exposing (Todo, TodoState)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view >> toUnstyled
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


view : Model -> Html.Styled.Html Msg
view model =
    div
        [ css
            [ paddingLeft (px 20)
            , backgroundColor (hex "f5f5f5")
            , width (pct 100)
            , height (pct 100)
            , textAlign center
            , fontFamilies [ "Helvetica Neue", "Helvetica", "Arial", "sans-serif" ]
            ]
        ]
        [ h1
            [ css
                [ margin (px 0)
                , width (pct 100)
                , fontSize (px 100)
                , fontWeight (int 100)
                , textAlign center
                , color (rgba 175 47 47 0.15)
                , textRendering optimizeLegibility
                ]
            ]
            [ text "todos" ]
        , todoListSelector model.todoLists
        , div
            [ css
                [ border3 (px 1) solid (hex "e6e6e6")
                , margin2 (px 0) (px 50)
                , boxShadow5 (px 0) (px 2) (px 4) (px 0) (rgba 0 0 0 0.2)
                , boxShadow5 (px 0) (px 25) (px 50) (px 0) (rgba 0 0 0 0.1)
                , position relative
                , before
                    [ property "content" "''"
                    , position absolute
                    , right (px 0)
                    , bottom (px 0)
                    , left (px 0)
                    , height (px 50)
                    , overflow hidden
                    , property "box-shadow" "0 1px 1px rgba(0, 0, 0, 0.2), 0 8px 0 -3px #f6f6f6, 0 9px 1px -3px rgba(0, 0, 0, 0.2), 0 16px 0 -6px #f6f6f6, 0 17px 2px -6px rgba(0, 0, 0, 0.2)"
                    ]
                ]
            ]
            [ addList model.newList
            , addTask model.newTodo
            , displayTasks model.todoState
            ]
        ]


todoListSelector : SelectList String -> Html.Styled.Html Msg
todoListSelector todoLists =
    ul
        [ css
            [ displayFlex
            , listStyleType none
            ]
        ]
        (todoLists
            |> SelectList.mapBy
                (\position list ->
                    li
                        [ onClick (ChangeList list)
                        , css
                            ([ padding (px 10)
                             ]
                                ++ (if position == SelectList.Selected then
                                        [ backgroundColor Css.Colors.gray, color Css.Colors.white ]
                                    else
                                        []
                                   )
                            )
                        ]
                        [ text list ]
                )
            |> SelectList.toList
        )


addList : String -> Html.Styled.Html Msg
addList currentValue =
    form [ onSubmit AddList, css [ borderBottom3 (px 2) solid (hex "ededed") ] ]
        [ input
            [ onInput NewList
            , value currentValue
            , css
                [ width (pct 85)
                , margin (px 0)
                , padding (px 16)
                , border (px 0)
                , boxShadow5 inset (px 0) (px -2) (px 1) (rgba 0 0 0 0.03)
                , boxSizing borderBox
                ]
            ]
            []
        , button
            [ type_ "submit"
            , css
                [ width (pct 15)
                , margin (px 0)
                , padding (px 16)
                , borderLeft3 (px 1) solid (hex "ededed")
                , boxSizing borderBox
                ]
            ]
            [ text "Add List" ]
        ]


addTask : String -> Html.Styled.Html Msg
addTask currentValue =
    form [ onSubmit AddTodo ]
        [ input
            [ onInput NewTodo
            , value currentValue
            , placeholder "What needs to be done?"
            , css
                [ width (pct 100)
                , margin (px 0)
                , padding (px 16)
                , border (px 0)
                , boxShadow5 inset (px 0) (px -2) (px 1) (rgba 0 0 0 0.03)
                , boxSizing borderBox
                ]
            ]
            []
        ]


displayTasks : Todo.TodoState -> Html.Styled.Html Msg
displayTasks todoState =
    ul
        [ css
            [ listStyleType none
            , margin (px 0)
            , padding (px 0)
            , backgroundColor Css.Colors.white
            , textAlign left
            ]
        ]
        (todoState
            |> Todo.getTodoList
            |> List.map
                (\todo ->
                    li
                        [ css
                            [ padding2 (px 10) (px 30)
                            , borderBottom3 (px 1) solid (hex "ededed")
                            ]
                        ]
                        [ text todo.name ]
                )
        )
