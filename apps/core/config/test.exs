use Mix.Config

config :core, Core.Repo,
  pool: Ecto.Adapters.SQL.Sandbox

import_config "test.secret.exs"
