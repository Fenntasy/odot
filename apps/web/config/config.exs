use Mix.Config

config :web,
  namespace: Web

config :web, WebWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SCRF0ep6uROznuzWcMh9qDRMEosZut0DzJLm4mepS/m0TX5P/D6vHgIFs5H/XCDI",
  render_errors: [view: WebWeb.ErrorView, accepts: ~w(html)],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :web, Web.Todo, root_url: "http://localhost:4000"

import_config "#{Mix.env}.exs"
