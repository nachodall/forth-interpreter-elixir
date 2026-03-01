defmodule ForthInterpreterElixir.InterpretersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ForthInterpreterElixir.Interpreters` context.
  """

  @doc """
  Generate a execution.
  """
  def execution_fixture(attrs \\ %{}) do
    {:ok, execution} =
      attrs
      |> Enum.into(%{
        input: "some input",
        result: "some result"
      })
      |> ForthInterpreterElixir.Interpreters.create_execution()

    execution
  end
end
