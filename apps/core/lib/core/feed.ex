defmodule Core.Feed do
  @moduledoc """
  Functions for working with user's posts.
  """

  alias Core.Accounts.User
  alias Core.Feed.Post
  alias Core.Repo
  alias Core.EventRepo

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
  def create_post(%{} = attrs) do
    with {:ok, post} <- Post.create_changeset(attrs) |> Repo.insert(), 
      post <- Repo.preload(post, :user),
      :ok <- EventRepo.save_event(:post_created, {post.user_id, post.id, post.text, post.inserted_at}) do
        {:ok, post}
      end
  end
end
