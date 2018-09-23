defmodule Core.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:text, :string, null: false)
      add(:user_id, references(:users), on_delete: :delete_all)

      timestamps()
    end
  end
end
