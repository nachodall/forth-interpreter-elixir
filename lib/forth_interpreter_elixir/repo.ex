defmodule ForthInterpreterElixir.Repo do
  use Ecto.Repo,
    otp_app: :forth_interpreter_elixir,
    adapter: Ecto.Adapters.Postgres
end
