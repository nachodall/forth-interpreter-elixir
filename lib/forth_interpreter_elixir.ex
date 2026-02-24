defmodule Forth do
  @moduledoc """
  Core logic for the Forth Interpreter.
  """

  import Bitwise

  def eval(input, initial_stack \\ []) do
    stack = Enum.reverse(initial_stack)

    input
    |> String.downcase()
    |> String.split()
    |> evaluate_tokens(stack, %{})
  end

  defp evaluate_tokens([], stack, _) do
    {:ok, Enum.reverse(stack)}
  end

  defp evaluate_tokens([":" | xs], stack, dict) do
    parse_definition(xs, [], stack, dict)
  end

  defp evaluate_tokens([x | xs], stack, dict) when is_map_key(dict, x) do
    user_defined_words = Map.fetch!(dict, x)
    evaluate_tokens(user_defined_words ++ xs, stack, dict)
  end

  defp evaluate_tokens(["+" | xs], [snd, fst | ys], dict),
    do: evaluate_tokens(xs, [fst + snd | ys], dict)

  defp evaluate_tokens(["-" | xs], [snd, fst | ys], dict),
    do: evaluate_tokens(xs, [fst - snd | ys], dict)

  defp evaluate_tokens(["*" | xs], [snd, fst | ys], dict),
    do: evaluate_tokens(xs, [fst * snd | ys], dict)

  defp evaluate_tokens(["/" | _], [0, _ | _], _), do: {:error, "division by zero"}

  defp evaluate_tokens(["/" | xs], [snd, fst | ys], dict),
    do: evaluate_tokens(xs, [div(fst, snd) | ys], dict)

  defp evaluate_tokens(["dup" | xs], [fst | ys], dict),
    do: evaluate_tokens(xs, [fst, fst | ys], dict)

  defp evaluate_tokens(["drop" | xs], [_ | ys], dict), do: evaluate_tokens(xs, ys, dict)

  defp evaluate_tokens(["swap" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [snd, fst | ys], dict)

  defp evaluate_tokens(["over" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [snd, fst, snd | ys], dict)

  defp evaluate_tokens(["rot" | xs], [fst, snd, thrd | ys], dict),
    do: evaluate_tokens(xs, [thrd, fst, snd | ys], dict)

  defp evaluate_tokens(["nip" | xs], [fst, _ | ys], dict),
    do: evaluate_tokens(xs, [fst | ys], dict)

  defp evaluate_tokens(["tuck" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [fst, snd, fst | ys], dict)

  defp evaluate_tokens(["2dup" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [fst, snd, fst, snd | ys], dict)

  defp evaluate_tokens(["2drop" | xs], [_, _ | ys], dict), do: evaluate_tokens(xs, ys, dict)

  defp evaluate_tokens(["2swap" | xs], [fst, snd, thrd, frth | ys], dict),
    do: evaluate_tokens(xs, [thrd, frth, fst, snd | ys], dict)

  defp evaluate_tokens(["2over" | xs], [fst, snd, thrd, frth | ys], dict),
    do: evaluate_tokens(xs, [thrd, frth, fst, snd, thrd, frth | ys], dict)

  defp evaluate_tokens(["=" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [if(snd == fst, do: -1, else: 0) | ys], dict)

  defp evaluate_tokens([">" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [if(snd > fst, do: -1, else: 0) | ys], dict)

  defp evaluate_tokens(["<" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [if(snd < fst, do: -1, else: 0) | ys], dict)

  defp evaluate_tokens(["and" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [band(snd, fst) | ys], dict)

  defp evaluate_tokens(["or" | xs], [fst, snd | ys], dict),
    do: evaluate_tokens(xs, [bor(snd, fst) | ys], dict)

  defp evaluate_tokens(["not" | xs], [fst | ys], dict),
    do: evaluate_tokens(xs, [if(fst == 0, do: -1, else: 0) | ys], dict)

  defp evaluate_tokens(["invert" | xs], [fst | ys], dict),
    do: evaluate_tokens(xs, [bnot(fst) | ys], dict)

  defp evaluate_tokens([op | _], _, _)
       when op in [
              "+",
              "-",
              "*",
              "/",
              "dup",
              "drop",
              "swap",
              "over",
              "rot",
              "nip",
              "tuck",
              "2dup",
              "2drop",
              "2swap",
              "2over",
              "=",
              ">",
              "<",
              "and",
              "or",
              "not",
              "invert"
            ],
       do: {:error, "stack underflow"}

  defp evaluate_tokens([x | xs], stack, dict) do
    case Integer.parse(x) do
      {num, ""} -> evaluate_tokens(xs, [num | stack], dict)
      _error -> {:error, "unknown word: #{x}"}
    end
  end

  defp parse_definition([x | xs], acc, stack, dict) when x != ";" do
    parse_definition(xs, [x | acc], stack, dict)
  end

  defp parse_definition([";" | xs], acc, stack, dict) do
    case Enum.reverse(acc) do
      [] ->
        {:error, "invalid word definition"}

      [name | instructions] ->
        case Integer.parse(name) do
          {_num, ""} -> {:error, "invalid word definition"}
          _error -> evaluate_tokens(xs, stack, Map.put(dict, name, instructions))
        end
    end
  end

  defp parse_definition([], _, _, _) do
    {:error, "unterminated definition"}
  end
end
