defmodule TodoListTest do
  use ExUnit.Case
  alias Kaur.Result
  alias TodoList
  alias Todo.Task

  setup do
    todo_list =
      []
      |> Todo.List.add(%{name: "Code"})
      |> Result.and_then(&Todo.List.add(&1, %{name: "Eat"}))
      |> Result.and_then(&Todo.List.add(&1, %{name: "Sleep"}))
      |> Result.with_default([])

    {:ok, list: todo_list}
  end

  test "add: add a new todo to an empty todolist" do
    assert {:ok, [%Task{name: "Code", done: false}]} = Todo.List.add([], %{name: "Code"})
  end

  test "add: add a new todo to an existing todolist", %{list: list} do
    assert {:ok, [%Task{name: "Code", done: false},
                  %Task{name: "Eat", done: false},
                  %Task{name: "Sleep", done: false},
                  %Task{name: "Repeat", done: false}]} = Todo.List.add(list, %{name: "Repeat"})
  end

  test "remove: remove a non existing todo", %{list: list} do
    assert list == Todo.List.remove(list, 42)
  end

  test "remove: remove an existing todo", %{list: list} do
    assert [%Task{name: "Code", done: false}, %Task{name: "Sleep", done: false}] = Todo.List.remove(list, Enum.at(list, 1).id)
  end

  test "done: mark an existing todo as done", %{list: list} do
    assert list == Todo.List.done(list, 42)
  end

  test "done: mark a non existing todo as done", %{list: list} do
    assert [%Task{name: "Code", done: false}, %Task{name: "Eat", done: true}, %Task{name: "Sleep", done: false}] = Todo.List.done(list, Enum.at(list, 1).id)
  end
end
