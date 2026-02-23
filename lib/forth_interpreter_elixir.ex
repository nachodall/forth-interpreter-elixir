defmodule Forth do
  @moduledoc """
  Core logic for the Forth Interpreter.
  """

  def eval(input, initial_stack \\ []) do
    stack = Enum.reverse(initial_stack)

    input
    |> String.split()
    |> evaluate_tokens(stack)
  end

  defp evaluate_tokens([], stack) do
    {:ok, Enum.reverse(stack)}
  end

  defp(evaluate_tokens(["+" | xs], [snd, fst | ys]), do: evaluate_tokens(xs, [fst + snd | ys]))
  defp evaluate_tokens(["-" | xs], [snd, fst | ys]), do: evaluate_tokens(xs, [fst - snd | ys])
  defp evaluate_tokens(["*" | xs], [snd, fst | ys]), do: evaluate_tokens(xs, [fst * snd | ys])
  defp evaluate_tokens(["/" | _], [0, _ | _]), do: {:error, "division by zero"}
  defp evaluate_tokens(["/" | xs], [snd, fst | ys]), do: evaluate_tokens(xs, [div(fst, snd) | ys])

  defp evaluate_tokens([x | xs], stack) do
    case Integer.parse(x) do
      {num, ""} ->
        evaluate_tokens(xs, [num | stack])

      _error ->
        {:error, "unknown word: #{x}"}
    end
  end
end
