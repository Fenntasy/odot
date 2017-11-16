defmodule Todo.SupervisorTest do
  use ExUnit.Case, async: true

  test "start: creates a todolist" do
    {:ok, pid} = Todo.Supervisor.start_link

    assert {:ok, _pid} = Todo.Supervisor.start_child(pid, "some_todolist_name", :server_name)
  end
end
