defmodule WebWeb.Router do
  use WebWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", WebWeb do
    pipe_through :browser

    scope "/:name" do
      resources "/", TodoController, only: [:index]
    end
  end
end
