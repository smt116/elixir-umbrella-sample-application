defmodule Core.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    configure_mnesia()
    children = [Core.Repo]
    opts = [strategy: :one_for_one, name: Core.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp configure_mnesia() do
    :mnesia.create_schema([node()])
    Application.ensure_started(:mnesia)
    :mnesia.create_table(Event, [attributes: [:id, :user_id, :operation, :values, :time], disc_copies: [node()], type: :ordered_set])
  end
end
