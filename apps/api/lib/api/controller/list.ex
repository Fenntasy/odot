defmodule API.Controller.List do
  use API.Controller
  alias Todo

  def index(conn) do
    {:ok, list} = Todo.list(conn.params["name"])

    render(conn, API.View.List, "index.json", 200, list: list)
  end

  def create(conn) do
    todo = Todo.add(conn.params["name"], conn.body_params)

    case todo do
      {:ok, list} ->
        render(conn, API.View.List, "index.json", 200, list: list)
      {:error, errors} ->
        render(conn, API.View.Error, "422.json", 422, errors: errors)
    end
  end
end
