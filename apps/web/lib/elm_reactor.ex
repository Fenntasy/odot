defmodule ElmReactor do
  use Task

  def start_link() do
    if Mix.env() === :dev do
      Task.start_link(__MODULE__, :run, [])
    else
      :ignore
    end
  end

  def run() do
    System.cmd(
      "bash",
      [File.cwd!() <> "/necromancer.sh", "elm-reactor"],
      cd: File.cwd!() <> "/client",
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true
    )
  end
end
