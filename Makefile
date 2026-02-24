.PHONY: setup build test format clean console

setup:
	mix deps.get

build: setup
	mix compile

test:
	mix test

format:
	mix format

clean:
	mix clean

console:
	iex -S mix
