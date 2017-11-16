defmodule Todo.Server do
  use GenServer
  alias Todo.List

  defstruct name: nil, tasks: []

  def start_link(name, options \\ []) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: name}, options)
  end

  def add(pid, params) do
    GenServer.call(pid, {:add, params})
  end

  def done(pid, task_id) do
    GenServer.call(pid, {:done, task_id})
  end

  def list(pid) do
    GenServer.call(pid, :list)
  end

  def remove(pid, task_id) do
    GenServer.call(pid, {:remove, task_id})
  end

  def handle_call({:add, params}, _pid, state) do
    case List.add(state.tasks, params) do
      {:ok, tasks} ->
        {:reply, {:ok, tasks}, %__MODULE__{state | tasks: tasks}}
      {:error, error} ->
        {:reply, {:error, error}, state}
    end
  end
  def handle_call({:done, task_id}, _pid, state) do
    tasks = List.done(state.tasks, task_id)

    {:reply, {:ok, tasks}, %__MODULE__{state | tasks: tasks}}
  end
  def handle_call(:list, _pid, state) do
    {:reply, {:ok, state.tasks}, state}
  end
  def handle_call({:remove, task_id}, _pid, state) do
    tasks = List.remove(state.tasks, task_id)

    {:reply, {:ok, tasks}, %__MODULE__{state | tasks: tasks}}
  end
end
