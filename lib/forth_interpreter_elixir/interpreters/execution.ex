defmodule ForthInterpreterElixir.Interpreters.Execution do
  use Ecto.Schema
  import Ecto.Changeset

  schema "executions" do
    field :input, :string
    field :result, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(execution, attrs) do
    execution
    |> cast(attrs, [:input, :result])
    |> validate_required([:input, :result])
  end
end
