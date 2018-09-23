use Mix.Config

config :api,
  namespace: Api

config :api, ApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0lVFSbKYFUSEwUVD647N/7fLWhCrpwefF2yvPaTQ0rnF67TBp+XZV/ywx3IkUQA4",
  render_errors: [view: ApiWeb.ErrorView, accepts: ~w(json)]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

import_config "#{Mix.env}.exs"
