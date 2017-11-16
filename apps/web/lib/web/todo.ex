defmodule Web.Todo do
  alias Kaur.Result

  def list(todolist_name) do
    todolist_name
    |> build_url()
    |> HTTPoison.get()
    |> Result.map(&(&1.body))
    |> Result.and_then(&Poison.decode/1)
    |> Result.map(&Map.get(&1, "list"))
    |> Result.map_error(fn _ -> :api_unavailable end)
  end

  defp build_url(todolist_name) do
    root_url() <> "/lists/" <> todolist_name
  end

  defp root_url do
    Application.get_env(:web, Web.Todo)[:root_url]
  end
end
