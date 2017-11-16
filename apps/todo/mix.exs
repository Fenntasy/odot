defmodule Todo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :todo,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      deps: deps(),
      elixir: "~> 1.5",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env == :prod,
      version: "0.1.0"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Todo.Application, []}
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.2.6"},
      {:kaur, "~> 1.0.0"}
    ]
  end
end
