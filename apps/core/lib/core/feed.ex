defmodule Core.Feed do
  @moduledoc """
  Functions for working with user's posts.
  """

  alias Core.Accounts.User
  alias Core.Feed.Post
  alias Core.Repo

  import Ecto.Query

  @spec posts() :: list(Post.t())
  def posts do
    from(post in Post)
    |> join(:left, [record], user in assoc(record, :user))
    |> preload([_, user], user: user)
    |> order_by(:inserted_at)
    |> Repo.all()
  end

  @spec create_post(attrs :: map()) :: Repo.modify_result_t(Post.t())
  def create_post(%{} = attrs), do: Post.create_changeset(attrs) |> Repo.insert()
end
