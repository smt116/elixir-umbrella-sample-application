defmodule Core.DataCase do
  @moduledoc """
  Setup for tests requiring access to the data layer.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Core.Repo
      alias Ecto.Changeset

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Core.DataCase
    end
  end

  setup_all _tags do
    :ok
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Core.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, {:shared, self()})
    end

    :ok
  end
end
