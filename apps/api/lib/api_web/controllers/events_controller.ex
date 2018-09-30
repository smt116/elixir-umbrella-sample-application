defmodule ApiWeb.EventsController do
  @moduledoc """
  Web interface for viewing events
  """

  use ApiWeb, :controller

  alias Core.EventRepo

  action_fallback(ApiWeb.ErrorsController)

  def index(conn, _opts) do
    {:ok, events} = EventRepo.events()
    json(conn, %{data: %{events: events}})
  end

  def show(conn, %{"id" => raw_id}) do
    with {:ok, id} <- Helpers.Integer.parse(raw_id),
         {:ok, events} <- EventRepo.get_event(id) do
      json(conn, %{data: %{events: events}})
    end
  end

  def show(conn, %{"operation" => operation}) do
    with operation <- String.to_existing_atom(operation),
         {:ok, events} <- EventRepo.get_event(operation) do
      json(conn, %{data: %{events: events}})
    end
  end
end
