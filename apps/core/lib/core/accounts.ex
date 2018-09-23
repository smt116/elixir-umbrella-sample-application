defmodule Core.Accounts do
  @moduledoc """
  Functions for working with user-related data structures.
  """

  alias Core.Accounts.User
  alias Core.Repo

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
  def create_user(%{} = attrs), do: User.create_changeset(attrs) |> Repo.insert()

  @spec update_user(User.t(), attrs :: map()) :: Repo.modify_result_t(User.t())
  def update_user(%User{} = user, %{} = attrs) do
    User.update_changeset(user, attrs) |> Repo.update()
  end

  @spec delete_user(User.t()) :: Repo.modify_result_t(User.t())
  def delete_user(%User{} = user), do: Repo.delete(user)
end
