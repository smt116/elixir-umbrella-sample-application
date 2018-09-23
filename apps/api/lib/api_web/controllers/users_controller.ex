defmodule ApiWeb.UsersController do
  @moduledoc """
  Web interface for managing users.
  """

  use ApiWeb, :controller

  alias Core.Accounts

  action_fallback(ApiWeb.ErrorsController)

  def index(conn, _opts) do
    users = Accounts.users()
    json(conn, %{data: %{users: users}})
  end

  def show(conn, %{"id" => raw_id}) do
    with {:ok, id} <- Helpers.Integer.parse(raw_id),
         {:ok, user} <- Accounts.user(id) do
      json(conn, %{data: %{user: user}})
    end
  end

  def create(conn, %{"user" => attrs}) do
    with {:ok, user} <- Accounts.create_user(attrs) do
      json(conn, %{data: %{user: user}})
    end
  end

  def create(_, _), do: {:error, :invalid}

  def update(conn, %{"id" => raw_id, "user" => attrs}) do
    with {:ok, id} <- Helpers.Integer.parse(raw_id),
         {:ok, user} <- Accounts.user(id),
         {:ok, user} <- Accounts.update_user(user, attrs) do
      json(conn, %{data: %{user: user}})
    end
  end

  def update(_, _), do: {:error, :invalid}

  def delete(conn, %{"id" => raw_id}) do
    with {:ok, id} <- Helpers.Integer.parse(raw_id),
         {:ok, user} <- Accounts.user(id),
         {:ok, _} <- Accounts.delete_user(user) do
      json(conn, %{data: %{message: "OK"}})
    end
  end
end
