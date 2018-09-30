defmodule Core.Accounts do
  @moduledoc """
  Functions for working with user-related data structures.
  """

  alias Core.Accounts.User
  alias Core.Repo
  alias Core.EventRepo

  import Ecto.Query

  @spec users() :: list(User.t())
  def users do
    from(user in User)
    |> order_by(:email)
    |> Repo.all()
  end

  @spec user(id :: pos_integer()) :: Repo.select_result_t(User.t())
  def user(id) when is_integer(id), do: Repo.get_record(User, id)

  @spec create_user(attrs :: map()) :: Repo.modify_result_t(User.t())
  def create_user(%{} = attrs) do
    with {:ok, user} <- User.create_changeset(attrs) |> Repo.insert(),
         :ok <-
           EventRepo.save_event(
             :user_created,
             {user.id, Map.delete(attrs, "password"), user.inserted_at}
           ) do
      {:ok, user}
    end
  end

  @spec update_user(User.t(), attrs :: map()) :: Repo.modify_result_t(User.t())
  def update_user(%User{} = user, %{} = attrs) do
    with {:ok, user} <- User.update_changeset(user, attrs) |> Repo.update(),
         :ok <- EventRepo.save_event(:user_updated, {user.id, attrs, user.updated_at}) do
      {:ok, user}
    end
  end

  @spec delete_user(User.t()) :: Repo.modify_result_t(User.t())
  def delete_user(%User{} = user) do
    with {:ok, user} <- Repo.delete(user),
         :ok <- EventRepo.save_event(:user_deleted, {user.id, user.updated_at}) do
      {:ok, user}
    end
  end
end
