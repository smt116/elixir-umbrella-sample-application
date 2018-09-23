defmodule Core.FeedTest do
  use Core.DataCase, async: true

  alias Core.Accounts
  alias Core.Accounts.User
  alias Core.Feed
  alias Core.Feed.Post

  setup do
    [john_id, susan_id] =
      ["john@example.com", "susan@example.com"]
      |> Stream.map(fn email ->
        Accounts.create_user(
          %{
            email: email,
            password: "secret"
          }
        )
      end)
      |> Enum.map(fn {:ok, %User{id: id}} -> id end)

    {:ok, john_id: john_id, susan_id: susan_id}
  end

  describe "posts/0" do
    test "works when there are no records" do
      assert Feed.posts() === []
    end

    test "returns records", %{john_id: john_id, susan_id: susan_id} do
      Enum.each([
        %{user_id: john_id, text: "Hello World!"},
        %{user_id: susan_id, text: "Hi there"},
        %{user_id: john_id, text: "I'm looking for the new opportunities"}
      ], fn attrs ->
        assert {:ok, _} = Post.create_changeset(attrs) |> Repo.insert()
      end)

      assert Enum.count(Feed.posts()) === 3
    end
  end

  describe "create_post/1" do
    test "returns ok tuple on valid attrs", %{john_id: john_id} do
      assert {:ok, %Post{id: id} = post} =
        Feed.create_post(
          %{
            text: "Hello world!",
            user_id: john_id
          }
        )

      assert is_integer(id)
      assert post.text === "Hello world!"
      assert post.user_id === john_id
    end
  end
end
