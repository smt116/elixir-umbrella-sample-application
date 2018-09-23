use Mix.Config

config :api, ApiWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn
