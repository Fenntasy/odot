defmodule WebWeb.TodoController do
  use WebWeb, :controller

  def index(conn, params) do
    case Web.Todo.list(params["name"]) do
      {:ok, tasks} ->
        render conn, "index.html", name: params["name"], tasks: tasks
      {:error, _reason} ->
        render conn, WebWeb.ErrorView, "500.html"
    end
  end
end
