defmodule Core.AccountsTest do
  use Core.DataCase, async: true

  alias Core.Accounts
  alias Core.Accounts.User

  @john_attrs %{
    email: "john@example.com",
    password: "secret"
  }

  @susan_attrs %{
    email: "susan@example.com",
    password: "secret"
  }

  describe "users/0" do
    test "works when there are no records" do
      assert Accounts.users() === []
    end

    test "returns records" do
      assert {:ok, _} = User.create_changeset(@john_attrs) |> Repo.insert()
      assert {:ok, _} = User.create_changeset(@susan_attrs) |> Repo.insert()

      assert Enum.count(Accounts.users()) === 2
    end

    test "sorts results by email" do
      assert {:ok, _} = User.create_changeset(@susan_attrs) |> Repo.insert()
      assert {:ok, _} = User.create_changeset(@john_attrs) |> Repo.insert()

      assert Enum.map(Accounts.users(), & &1.email) === [
        "john@example.com",
        "susan@example.com"
      ]
    end
  end

  describe "user/1" do
    test "returns ok tuple" do
      assert {:ok, %{id: id}} =
        @john_attrs
        |> User.create_changeset()
        |> Repo.insert()

      assert {:ok, %User{email: "john@example.com"}} = Accounts.user(id)
    end

    test "returns not found when missing" do
      assert Accounts.user(0) === {:error, :not_found}
    end
  end

  describe "create_user/1" do
    test "returns ok tuple on valid attrs" do
      assert {:ok, %User{id: id} = user} = Accounts.create_user(@john_attrs)
      assert is_integer(id)
      assert user.email === "john@example.com"
      assert is_nil(user.first_name)
      assert is_nil(user.last_name)
      assert is_binary(user.password)
      assert is_binary(user.password_hash)
    end

  end

  describe "update_user/2" do
    test "returns ok tuple on valid attrs" do
      assert {:ok, %User{id: id} = user} =
        @susan_attrs
        |> User.create_changeset()
        |> Repo.insert()

      assert user.email === "susan@example.com"
      assert is_nil(user.first_name)
      assert is_nil(user.last_name)

      attrs = %{
        email: "susan.doe@example.com",
        first_name: "Susan",
        last_name: "Doe"
      }

      assert {:ok, %User{id: ^id} = user} = Accounts.update_user(user, attrs)
      assert user.email === "susan.doe@example.com"
      assert user.first_name === "Susan"
      assert user.last_name === "Doe"
    end

    test "returns error tuple on invalid attrs" do
      assert {:ok, %User{id: id} = user} =
        @susan_attrs
        |> User.create_changeset()
        |> Repo.insert()

      assert {:error, %Changeset{valid?: false}} =
        Accounts.update_user(user, %{password: "short"})
    end
  end

  describe "delete_user/1" do
    test "returns ok tuple" do
      assert {:ok, %User{id: id} = user} =
        @susan_attrs
        |> User.create_changeset()
        |> Repo.insert()

      assert {:ok, %User{__meta__: meta}} = Accounts.delete_user(user)
      assert meta.state === :deleted
      assert Repo.get(User, id) === nil
    end
  end
end
