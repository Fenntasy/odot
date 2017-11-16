defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Kaur.Result

  @primary_key {:id, :binary_id, autogenerate: true}
  embedded_schema do
    field :name, :string
    field :done, :boolean
  end

  def build(params) do
    changeset = changeset(params)

    if changeset.valid? do
      changeset
      |> apply_changes
      |> Result.ok
    else
      changeset.errors
      |> Result.error
    end
  end

  def mark_as_done(%__MODULE__{} = task) do
    %__MODULE__{task | done: true}
  end

  defp changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name])
    |> validate_required([:name])
    |> put_change(:done, false)
    |> put_change(:id, Ecto.UUID.generate)
  end
end
