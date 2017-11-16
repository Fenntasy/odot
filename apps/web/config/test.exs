use Mix.Config

config :web, WebWeb.Endpoint,
  http: [port: 5001],
  server: false

config :logger, level: :warn
