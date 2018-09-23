defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    resources "/users", UsersController, only: [:index, :show, :create, :update, :delete]
    resources "/posts", PostsController, only: [:index, :create]
  end
end
