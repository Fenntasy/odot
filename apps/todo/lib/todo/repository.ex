defmodule Todo.Repository do
  use Supervisor
  @registry :todo_registry

  def init(_) do
    children = [
      supervisor(Registry, [[keys: :unique, name: @registry]]),
      supervisor(Todo.Supervisor, [], id: :supervisor)
    ]

    supervise(children, strategy: :one_for_all)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def find_or_create(todolist_name) do
    case Registry.lookup(@registry, todolist_name) do
      [] ->
        __MODULE__
        |> find_supervisor_pid
        |> Todo.Supervisor.start_child(todolist_name, {:via, Registry, {@registry, todolist_name}})
      [{pid, _}] ->
        {:ok, pid}
    end
  end

  defp find_supervisor_pid(repository_pid) do
    Supervisor.which_children(repository_pid)
    |> Enum.find_value(fn
      {:supervisor, supervisor_pid, _, _} -> supervisor_pid
      _ -> nil
    end)
  end
end
