module TodoModule exposing (Todo, addTodo, fetchTodoList)

import Http
import Json.Decode
import Json.Encode


type alias Todo =
    { id : String
    , done : Bool
    , name : String
    }


todoDecoder : Json.Decode.Decoder Todo
todoDecoder =
    Json.Decode.map3 Todo
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "done" Json.Decode.bool)
        (Json.Decode.field "name" Json.Decode.string)


decoder : Json.Decode.Decoder (List Todo)
decoder =
    Json.Decode.field "list"
        (Json.Decode.list todoDecoder)


encoder : String -> Json.Encode.Value
encoder name =
    (Json.Encode.object
        [ ( "name", Json.Encode.string name )
        ]
    )


fetchTodoList : (Result Http.Error (List Todo) -> msg) -> Cmd msg
fetchTodoList message =
    Http.get "http://localhost:4000/lists/lillefp" decoder
        |> Http.send message


addTodo : (Result Http.Error (List Todo) -> msg) -> String -> Cmd msg
addTodo message name =
    Http.post "http://localhost:4000/lists/lillefp"
        (Http.jsonBody (encoder name))
        decoder
        |> Http.send message
