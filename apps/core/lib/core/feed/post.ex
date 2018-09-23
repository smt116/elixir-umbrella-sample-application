defmodule Core.Feed.Post do
  @moduledoc """
  A short, public message.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Core.Accounts.User
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "posts" do
    field(:text, :string)

    belongs_to(:user, User)

    timestamps()
  end

  @spec create_changeset(Post.t(), map()) :: Changeset.t()
  def create_changeset(%Post{} = post \\ %Post{}, %{} = attrs) do
    post
    |> cast(attrs, [:text, :user_id])
    |> validate_required([:text, :user_id])
    |> validate_length(:text, min: 3, max: 255)
    |> foreign_key_constraint(:user_id)
  end
end
