module TodoComponent
    exposing
        ( Todo
        , TodoState
        , addTodo
        , getTodoList
        , fetchTodoList
        , init
        , switchList
        )

import Http
import Json.Decode
import Json.Encode


type alias Todo =
    { id : String
    , done : Bool
    , name : String
    }


type alias TodoState =
    { todoList : List Todo
    , currentList : String
    }


init : TodoState
init =
    { todoList = []
    , currentList = "default"
    }


getTodoList : TodoState -> List Todo
getTodoList =
    .todoList


switchList : TodoState -> String -> TodoState
switchList todoState list =
    { todoState | currentList = list }


todoDecoder : Json.Decode.Decoder Todo
todoDecoder =
    Json.Decode.map3 Todo
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "done" Json.Decode.bool)
        (Json.Decode.field "name" Json.Decode.string)


decoder : TodoState -> Json.Decode.Decoder TodoState
decoder state =
    Json.Decode.field "list"
        (Json.Decode.list todoDecoder)
        |> Json.Decode.map
            (\todoList -> { state | todoList = todoList })


encoder : String -> Json.Encode.Value
encoder name =
    (Json.Encode.object
        [ ( "name", Json.Encode.string name )
        ]
    )


fetchTodoList : TodoState -> (Result Http.Error TodoState -> msg) -> Cmd msg
fetchTodoList state msg =
    Http.get
        ("http://localhost:4000/lists/" ++ state.currentList)
        (decoder state)
        |> Http.send msg


addTodo : TodoState -> (Result Http.Error TodoState -> msg) -> String -> Cmd msg
addTodo state msg name =
    Http.post ("http://localhost:4000/lists/" ++ state.currentList)
        (Http.jsonBody (encoder name))
        (decoder state)
        |> Http.send msg
