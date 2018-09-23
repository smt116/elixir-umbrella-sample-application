defmodule Core.Accounts.UserTest do
  use Core.DataCase, async: true

  alias Core.Accounts.User

  @valid_basic_attrs %{
    email: "user@example.com",
    password: "secret"
  }

  @valid_extended_attrs %{
    email: "user@example.com",
    first_name: "John",
    last_name: "Doe",
    password: "secret"
  }

  describe "create_changeset/2" do
    test "requires email and password" do
      assert %Changeset{errors: errors, valid?: false} =
        User.create_changeset(%{})

      assert errors === [
        email: {"can't be blank", [validation: :required]},
        password: {"can't be blank", [validation: :required]}
      ]
    end

    test "requires a valid email format" do
      assert %Changeset{errors: errors, valid?: false} =
        User.create_changeset(%{email: "user"})

      assert errors[:email] === {"has invalid format", [validation: :format]}
    end

    test "requires a valid password" do
      assert %Changeset{errors: errors, valid?: false} =
        User.create_changeset(%{password: "short"})

      assert errors[:password] === {
        "should be at least %{count} character(s)",
        [count: 6, validation: :length, min: 6]
      }
    end

    test "works for a valid basic attrs" do
      assert %Changeset{valid?: true} = User.create_changeset(@valid_basic_attrs)
    end

    test "works for a valid extedned attrs" do
      assert %Changeset{valid?: true} =
        User.create_changeset(@valid_extended_attrs)
    end

    test "hashes password" do
      assert %Changeset{changes: changes, valid?: true} =
        User.create_changeset(@valid_basic_attrs)

      assert is_binary(changes.password_hash)
    end

    test "ignores custom password hash" do
      assert %Changeset{changes: changes, valid?: true} =
        @valid_basic_attrs
        |> Map.put(:password_hash, "foo")
        |> User.create_changeset()

      assert is_binary(changes.password_hash)
      refute changes.password_hash === "foo"
    end
  end

  describe "update_changeset/2" do
    setup do
      {:ok, user: %User{email: "john@example.com", first_name: "John"}}
    end

    test "doesn't require email and password", %{user: user} do
      assert %Changeset{valid?: true} =
        User.update_changeset(user, %{})
    end

    test "doesn't calculate new password hash when missing", %{user: user} do
      assert %Changeset{changes: changes, valid?: true} =
        User.update_changeset(user, %{first_name: "Mark"})

      refute Map.has_key?(changes, :password_hash)
    end

    test "requires a valid email format", %{user: user} do
      assert %Changeset{errors: errors, valid?: false} =
        User.update_changeset(user, %{email: "user"})

      assert errors[:email] === {"has invalid format", [validation: :format]}
    end

    test "requires a valid password", %{user: user} do
      assert %Changeset{errors: errors, valid?: false} =
        User.update_changeset(user, %{password: "short"})

      assert errors[:password] === {
        "should be at least %{count} character(s)",
        [count: 6, validation: :length, min: 6]
      }
    end

    test "works for a valid attrs", %{user: user} do
      assert %Changeset{valid?: true} =
        User.update_changeset(user, @valid_extended_attrs)
    end

    test "hashes password", %{user: user} do
      assert %Changeset{changes: changes, valid?: true} =
        User.update_changeset(user, @valid_basic_attrs)

      assert is_binary(changes.password_hash)
    end

    test "ignores custom password hash", %{user: user} do
      attrs = Map.put(@valid_basic_attrs, :password_hash, "foo")

      assert %Changeset{changes: changes, valid?: true} =
        User.update_changeset(user, attrs)

      assert is_binary(changes.password_hash)
      refute changes.password_hash === "foo"
    end
  end
end
