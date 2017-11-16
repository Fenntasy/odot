defmodule Todo.ServerTest do
  use ExUnit.Case
  alias Todo.Server
  alias Todo.Task

  test "start: returns a PID" do
    {:ok, pid} = Server.start_link("some_list")

    assert Process.alive?(pid)
  end

  test "add: adds new todo in a todo list" do
    {:ok, pid} = Server.start_link("typical_day")

    assert {:ok, [%Task{name: "Code", done: false}]} = Server.add(pid, %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Server.add(pid, %{name: "Eat"})
  end

  test "done: mark a todo as done" do
    {:ok, pid} = Server.start_link("typical_day")

    assert {:ok, [%Task{name: "Code", done: false}]} = Server.add(pid, %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Server.add(pid, %{name: "Eat"})
    {:ok, list} = Server.list(pid)
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: true}]} = Server.done(pid, Enum.at(list, 1).id)
  end

  test "remove: deletes a todo" do
    {:ok, pid} = Server.start_link("typical_day")

    assert {:ok, [%Task{name: "Code", done: false}]} = Server.add(pid, %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Server.add(pid, %{name: "Eat"})
    {:ok, list} = Server.list(pid)
    assert {:ok, [%Task{name: "Code", done: false}]} = Server.remove(pid, Enum.at(list, 1).id)
  end
end
