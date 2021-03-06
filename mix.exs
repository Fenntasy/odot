defmodule Odot.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      deps: deps(),
      start_permanent: Mix.env() == :prod
    ]
  end

  defp deps do
    [{:cors_plug, "~> 1.5"}]
  end
end
