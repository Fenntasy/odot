defmodule API.Mixfile do
  use Mix.Project

  def project do
    [
      app: :api,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      deps: deps(),
      elixir: "~> 1.5",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env == :prod,
      version: "0.1.0",
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {API.Application, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
