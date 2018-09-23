defmodule Core.Feed.PostTest do
  use Core.DataCase, async: true

  alias Core.Feed.Post

  describe "create_changeset/2" do
    test "requires text and user reference" do
      assert %Changeset{errors: errors, valid?: false} =
        Post.create_changeset(%{})

      assert errors === [
        text: {"can't be blank", [validation: :required]},
        user_id: {"can't be blank", [validation: :required]}
      ]
    end

    test "requires text that is longer than 3 characters" do
      assert %Changeset{errors: errors, valid?: false} =
        Post.create_changeset(%{text: String.duplicate("a", 2)})

      assert errors[:text] === {
        "should be at least %{count} character(s)",
        [count: 3, validation: :length, min: 3]
      }
    end

    test "requires text that is shorter than 255 characters" do
      assert %Changeset{errors: errors, valid?: false} =
        Post.create_changeset(%{text: String.duplicate("a", 256)})

      assert errors[:text] === {
        "should be at most %{count} character(s)",
        [count: 255, validation: :length, max: 255]
      }
    end

    test "works for a valid attrs" do
      assert %Changeset{valid?: true} =
        Post.create_changeset(
          %{
            text: "Hello world!",
            user_id: 1
          }
        )
    end
  end
end
