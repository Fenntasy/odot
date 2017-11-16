defmodule TodoTest do
  use ExUnit.Case
  alias Todo
  alias Todo.Task

  test "add: adds new todo in a todo list" do
    assert {:ok, [%Task{name: "Code", done: false}]} = Todo.add("a_new_day", %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Todo.add("a_new_day", %{name: "Eat"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Todo.list("a_new_day")
  end

  test "done: mark a todo as done" do
    assert {:ok, [%Task{name: "Code", done: false}]} = Todo.add("a_done_day", %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Todo.add("a_done_day", %{name: "Eat"})
    {:ok, list} = Todo.list("a_done_day")
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: true}]} = Todo.done("a_done_day", Enum.at(list, 1).id)
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: true}]} = Todo.list("a_done_day")
  end

  test "remove: deletes a todo" do
    assert {:ok, [%Task{name: "Code", done: false}]} = Todo.add("a_delete_day", %{name: "Code"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Todo.add("a_delete_day", %{name: "Eat"})
    assert {:ok, [%Task{name: "Code", done: false}, %Task{name: "Eat", done: false}]} = Todo.list("a_delete_day")
    {:ok, list} = Todo.list("a_delete_day")
    assert {:ok, [%Task{name: "Code", done: false}]} = Todo.remove("a_delete_day", Enum.at(list, 1).id)
  end
end
