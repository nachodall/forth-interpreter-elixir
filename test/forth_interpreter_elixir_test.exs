defmodule ForthInterpreterElixirTest do
  use ExUnit.Case
  doctest ForthInterpreterElixir

  test "greets the world" do
    assert ForthInterpreterElixir.hello() == :world
  end
end
