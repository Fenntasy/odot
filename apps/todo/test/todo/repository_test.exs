defmodule Todo.RepositoryTest do
  use ExUnit.Case, async: false
  alias Todo.Repository

  test "find_or_create: returns a Todo.Server pid if it already exists" do
    {:ok, todo_pid} = Repository.find_or_create("some_existing_todo")

    assert {:ok, todo_pid} == Repository.find_or_create("some_existing_todo")
  end

  test "find_or_create: returns a new Todo.Server pid if it doesn't exist" do
    {:ok, todo1_pid} = Repository.find_or_create("todo1")
    {:ok, todo2_pid} = Repository.find_or_create("todo2")

    assert todo1_pid != todo2_pid
  end
end
