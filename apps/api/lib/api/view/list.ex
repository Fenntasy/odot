defmodule API.View.List do
  def render("index.json", %{list: list}) do
    %{list: list}
  end
end
