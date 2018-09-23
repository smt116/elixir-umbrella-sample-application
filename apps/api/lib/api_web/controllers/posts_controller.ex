defmodule ApiWeb.PostsController do
  @moduledoc """
  Web interface for managing posts.
  """

  use ApiWeb, :controller

  alias Core.Feed

  action_fallback(ApiWeb.ErrorsController)

  def index(conn, _opts) do
    posts = Feed.posts()
    json(conn, %{data: %{posts: posts}})
  end

  def create(conn, %{"post" => attrs}) do
    with {:ok, post} <- Feed.create_post(attrs) do
      json(conn, %{data: %{post: post}})
    end
  end

  def create(_, _), do: {:error, :invalid}
end
