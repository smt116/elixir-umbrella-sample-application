defmodule Core.Accounts.User do
  @moduledoc """
  A person that has access to the system.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Core.Feed.Post
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @derive {
    Poison.Encoder,
    only: [
      :email,
      :first_name,
      :id,
      :inserted_at,
      :last_name,
      :updated_at
    ]
  }
  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:posts, Post)

    timestamps()
  end

  @spec create_changeset(User.t(), map()) :: Changeset.t()
  def create_changeset(%User{} = user \\ %User{}, %{} = attrs) do
    changeset(user, attrs, [:email, :password])
  end

  @spec update_changeset(User.t(), map()) :: Changeset.t()
  def update_changeset(%User{} = user, %{} = attrs) do
    changeset(user, attrs)
  end

  @spec changeset(User.t(), map(), list(atom())) :: Changeset.t()
  defp changeset(%User{} = user, %{} = attrs, required_attributes \\ []) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :password])
    |> validate_required(required_attributes)
    |> with_email_changeset()
    |> with_password_changeset()
  end

  @spec with_email_changeset(Changeset.t()) :: Changeset.t()
  defp with_email_changeset(%Changeset{} = changeset) do
    changeset
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_lower_email__index)
  end

  @spec with_password_changeset(Changeset.t()) :: Changeset.t()
  defp with_password_changeset(%Changeset{} = changeset) do
    case changeset do
      %Changeset{changes: %{password: _password}} ->
        changeset
        |> validate_length(:password, min: 6)
        |> hash_password()

      _ ->
        changeset
    end
  end

  @spec hash_password(Changeset.t()) :: Changeset.t()
  defp hash_password(%Changeset{valid?: true, changes: changes} = changeset) do
    hash = Comeonin.Bcrypt.hashpwsalt(changes.password)
    put_change(changeset, :password_hash, hash)
  end

  defp hash_password(%Changeset{} = changeset), do: changeset
end
