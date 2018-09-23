use Mix.Config

config :bcrypt_elixir, :log_rounds, 2

config :core, Core.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, :console, level: :info

import_config "test.secret.exs"
