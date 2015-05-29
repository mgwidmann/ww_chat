defmodule WwChat.Router do
  use WwChat.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WwChat do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/activities", ActivityController
  end

  socket "/chat", WwChat do
    channel "rooms:lobby", RoomChannel
  end

  # Other scopes may use custom stacks.
  # scope "/api", WwChat do
  #   pipe_through :api
  # end
end
