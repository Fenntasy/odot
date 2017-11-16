defmodule Todo do
  alias Kaur.Result
  alias Todo.{Repository, Server}

  def add(todolist_name, params) do
    todolist_name
    |> call_on(&Server.add(&1, params))
  end

  def done(todolist_name, task_id) do
    todolist_name
    |> call_on(&Server.done(&1, task_id))
  end

  def list(todolist_name) do
    todolist_name
    |> call_on(&Server.list/1)
  end

  def remove(todolist_name, task_id) do
    todolist_name
    |> call_on(&Server.remove(&1, task_id))
  end

  defp call_on(todolist_name, function) do
    todolist_name
    |> Repository.find_or_create
    |> Result.and_then(function)
  end
end
