defmodule API.Router do
  use Plug.Router

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:json], json_decoder: Poison
  plug :match
  plug :dispatch

  get "/lists/:name",   do: API.Controller.List.index(conn)
  post "/lists/:name",  do: API.Controller.List.create(conn)

  match _ do
    send_resp(conn, 404, "404 - Not Found")
  end
end
