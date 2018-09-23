defmodule ApiWeb.UsersResponse do
  @moduledoc false

  import ExUnit.Assertions
  import Phoenix.ConnTest

  def assert_post_response(conn, %{} = expected_values \\ %{}) do
    assert %{"data" => %{"post" => post_response}} = json_response(conn, 200)
    assert_schema(post_response)

    Enum.each(expected_values, fn {key, value} ->
      assert post_response[key] === value
    end)

    post_response
  end

  def assert_posts_response(conn) do
    assert %{"data" => %{"posts" => post_responses}} = json_response(conn, 200)

    Enum.each(post_responses, &assert_schema/1)
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
end
