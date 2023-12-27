defmodule WtrmlnWeb.Router do
  use WtrmlnWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WtrmlnWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_live_flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WtrmlnWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/:seed", RoomLive.Index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WtrmlnWeb do
  #   pipe_through :api
  # end
end
