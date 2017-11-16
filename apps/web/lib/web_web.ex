defmodule WebWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: WebWeb
      import Plug.Conn
      import WebWeb.Router.Helpers
      import WebWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/web_web/templates", namespace: WebWeb

      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import WebWeb.Router.Helpers
      import WebWeb.ErrorHelpers
      import WebWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import WebWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
