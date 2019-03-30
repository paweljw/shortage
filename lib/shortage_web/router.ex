defmodule ShortageWeb.Router do
  use ShortageWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", ShortageWeb do
    pipe_through :browser

    get "/", PageController, :index

    # TODO: Except "index" (useful for debugging)
    resources "/links", LinkController, except: [:edit, :update]

    get "/:shortened", ShortenedController, :show
  end
end
