defmodule Todo.Supervisor do
  use Supervisor

  def start_child(pid, todolist_name, name_from_registry) do
    Supervisor.start_child(pid, [todolist_name, [name: name_from_registry]])
  end

  def init(_) do
    children = [
      worker(Todo.Server, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end
end
