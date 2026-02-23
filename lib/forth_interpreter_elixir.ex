defmodule ForthInterpreter do
  @moduledoc """
  Core logic for the Interpreter.
  """

  defstruct stack: [], words: %{}

  def new, do: %__MODULE__{}

  def eval(state, _input) do
    {:ok, state}
  end
end
