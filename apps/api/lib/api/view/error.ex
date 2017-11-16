defmodule API.View.Error do
  def render("422.json", %{errors: errors}) do
    %{
      code: 422,
      message: "422 - Unprocessable Entity",
      errors: display_errors(errors)
    }
  end

  defp display_errors(errors) do
    errors
    |> Enum.map(fn {field, detail} -> {field, render_detail(detail)} end)
    |> Enum.into(%{})
  end

  defp render_detail({message, values}) do
    Enum.reduce values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end
  end
end
