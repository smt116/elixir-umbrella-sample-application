defmodule ApiWeb.UsersControllerTest do
  use ApiWeb.ConnCase, async: true

  import Phoenix.ConnTest

  alias Core.Accounts

  def assert_user_response(conn, %{} = expected_values \\ %{}) do
    assert %{"data" => %{"user" => user_response}} = json_response(conn, 200)
    assert_schema(user_response)

    Enum.each(expected_values, fn {key, value} ->
      assert user_response[key] === value
    end)

    user_response
  end

  def assert_users_response(conn) do
    assert %{"data" => %{"users" => user_responses}} = json_response(conn, 200)

    Enum.each(user_responses, &assert_schema/1)
  end

  def assert_schema(response) do
    assert is_binary(response["email"])
    assert is_binary(response["first_name"]) || is_nil(response["first_name"])
    assert is_binary(response["inserted_at"])
    assert is_binary(response["last_name"]) || is_nil(response["last_name"])
    assert is_binary(response["updated_at"])
    assert is_number(response["id"])

    assert Map.keys(response) === [
      "email",
      "first_name",
      "id",
      "inserted_at",
      "last_name",
      "updated_at"
    ]
  end

  describe "index/2" do
    test "returns records", %{conn: conn} do
      Accounts.create_user(%{email: "john@example.com", password: "secret"})
      Accounts.create_user(%{email: "susan@example.com", password: "secret"})

      conn
      |> get(users_path(conn, :index))
      |> assert_users_response()
    end
  end

  describe "show/2" do
    test "returns a record", %{conn: conn} do
      assert {:ok, user} =
        Accounts.create_user(
          %{
            email: "john@example.com",
            first_name: "John",
            last_name: "Doe",
            password: "secret"
          }
        )

      conn
      |> get(users_path(conn, :show, user.id))
      |> assert_user_response(%{
        "email" => "john@example.com",
        "first_name" => "John",
        "id" => user.id,
        "last_name" => "Doe"
      })
    end

    test "returns a not found when user doesn't exist", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Not Found"}} ===
        conn
        |> get(users_path(conn, :show, 0))
        |> json_response(404)
    end
  end

  describe "create/2" do
    test "returns record on valid params", %{conn: conn} do
      attrs =
        %{
          email: "mark@example.com",
          password: "secret"
        }

      conn
      |> post(users_path(conn, :create), %{"user" => attrs})
      |> assert_user_response(%{"email" => "mark@example.com"})
    end

    test "returns unprocessable entity on invalid params", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Unprocessable Entity"}} ===
        conn
        |> post(users_path(conn, :create), %{"user" => %{password: "short"}})
        |> json_response(422)
    end

    test "returns bad request on invalid request", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Bad Request"}} ===
        conn
        |> post(users_path(conn, :create))
        |> json_response(400)
    end
  end

  describe "update/2" do
    setup do
      {:ok, %{id: id}} =
        Accounts.create_user(
          %{
            email: "john@example.com",
            password: "secret"
          }
        )

      {:ok, id: id}
    end

    test "returns record on valid params", %{conn: conn, id: id} do
      attrs =
        %{
          first_name: "John",
          last_name: "Doe"
        }

      conn
      |> patch(users_path(conn, :update, id), %{"user" => attrs})
      |> assert_user_response(
        %{
          "id" => id,
          "email" => "john@example.com",
          "first_name" => "John",
          "last_name" => "Doe"
        }
      )
    end

    test "returns unprocessable entity on invalid params", %{conn: conn, id: id} do
      assert %{"errors" => %{"detail" => "Unprocessable Entity"}} ===
        conn
        |> patch(users_path(conn, :update, id), %{"user" => %{password: "short"}})
        |> json_response(422)
    end

    test "returns bad request on invalid request", %{conn: conn, id: id} do
      assert %{"errors" => %{"detail" => "Bad Request"}} ===
        conn
        |> patch(users_path(conn, :update, id))
        |> json_response(400)
    end

    test "returns not found when record does not exist", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Not Found"}} ===
        conn
        |> patch(users_path(conn, :update, 0), %{"user" => %{}})
        |> json_response(404)
    end
  end

  describe "delete/2" do
    test "returns ok on success", %{conn: conn} do
      {:ok, %{id: id}} =
        Accounts.create_user(
          %{
            email: "john@example.com",
            password: "secret"
          }
        )

      assert %{"data" => %{"message" => "OK"}} ===
        conn
        |> delete(users_path(conn, :delete, id))
        |> json_response(200)
    end

    test "returns not found when record does not exist", %{conn: conn} do
      assert %{"errors" => %{"detail" => "Not Found"}} ===
        conn
        |> delete(users_path(conn, :delete, 0))
        |> json_response(404)
    end
  end
end
