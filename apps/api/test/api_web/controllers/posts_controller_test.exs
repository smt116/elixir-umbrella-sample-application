defmodule ApiWeb.PostsControllerTest do
  use ApiWeb.ConnCase, async: true

  import Phoenix.ConnTest
  import ApiWeb.PostsResponse

  alias Core.Accounts
  alias Core.Feed

  setup do
    [john_id, susan_id] =
      ["mark@example.com", "susan@example.com"]
      |> Stream.map(fn email ->
        Accounts.create_user(
          %{
            email: email,
            password: "secret"
          }
        )
      end)
      |> Enum.map(fn {:ok, %{id: id}} -> id end)

    {:ok, john_id: john_id, susan_id: susan_id}
  end

  describe "index/2" do
    test "returns records", %{conn: conn, john_id: john_id, susan_id: susan_id} do
      Enum.each([
        %{user_id: john_id, text: "Hello World!"},
        %{user_id: susan_id, text: "Hi there"},
        %{user_id: john_id, text: "I'm looking for new opportunities"}
      ], &Feed.create_post/1)

      conn
      |> get(posts_path(conn, :index))
      |> assert_posts_response()
    end
  end

  describe "create/2" do
    test "returns record on valid params", %{conn: conn, john_id: john_id} do
      attrs =
        %{
          text: "Hello World!",
          user_id: john_id
        }

      conn
      |> post(posts_path(conn, :create), %{"post" => attrs})
      |> assert_post_response(%{"text" => "Hello World!"})
    end

    test "returns unprocessable entity on invalid params", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Unprocessable Entity"}} ===
        conn
        |> post(posts_path(conn, :create), %{"post" => %{text: "Hello!"}})
        |> json_response(422)
    end

    test "returns bad request on invalid request", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Bad Request"}} ===
        conn
        |> post(posts_path(conn, :create))
        |> json_response(400)
    end
  end
end
