# Forth Interpreter

An implementation of a Forth interpreter in Elixir, developed for the LambdaClass Engineering Residency.

## Dependencies

- Elixir ~> 1.18.2
- Erlang/OTP ~> 27.2.1

## Setup and Compilation

To fetch dependencies and compile the project, run:

    make setup
    make build

## Testing

To execute the test suite:

    make test

## Usage

You can interact with the interpreter using the Elixir REPL (IEx) via the provided Makefile target:

    make console

Inside the interactive shell, evaluate expressions using Forth.eval/1:

    iex> Forth.eval(": square dup * ; 5 square")
    {:ok, [25]}

## Supported Features

- Arithmetic operations: +, -, *, /
- Stack manipulations: dup, drop, swap, over, rot, nip, tuck
- Double operations: 2dup, 2drop, 2swap, 2over
- Logic and comparison: =, >, <, and, or, not, invert
- User-defined words: Support for recursive evaluation and dictionary state using : and ;
