defmodule Todo.List do
  alias Kaur.Result
  alias Todo.Task

  def add(list, params) do
    params
    |> Task.build
    |> Result.map(&List.insert_at(list, -1, &1))
  end

  def remove(list, id) do
    Enum.reject(list, fn task -> id == task.id end)
  end

  def done(list, id) do
    Enum.map(list, fn task ->
      if task.id == id do
        Task.mark_as_done(task)
      else
        task
      end
    end)
  end
end
