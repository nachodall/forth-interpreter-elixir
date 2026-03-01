defmodule ForthInterpreterElixir.Repo.Migrations.CreateExecutions do
  use Ecto.Migration

  def change do
    create table(:executions) do
      add :input, :text
      add :result, :text

      timestamps(type: :utc_datetime)
    end
  end
end
