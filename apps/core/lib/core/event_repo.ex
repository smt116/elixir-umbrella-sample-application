defmodule Core.EventRepo do
  @type operation ::
          :user_created
          | :user_updated
          | :user_deleted
          | :post_created

@spec save_event(operation, {pos_integer(), String.t(), any()}) :: :ok | {:error, any()}
  def save_event(:user_created, {user_id, user_email, time}),
    do: write_to_mnesia(user_id, :user_created, %{user_email: user_email}, time)

  def save_event(:user_updated, {user_id, attrs, time}),
    do: write_to_mnesia(user_id, :user_updated, attrs, time)

  def save_event(:user_deleted, {user_id, time}),
    do: write_to_mnesia(user_id, :user_deleted, %{}, time)

  def save_event(:post_created, {user_id, post_id, post_body, time}),
    do:
      write_to_mnesia(
        user_id,
        :post_created,
        %{user_id: user_id, post_id: post_id, post_body: post_body},
        time
      )

  def save_event(_, _), do: {:error, :invalid_operation}

  defp write_to_mnesia(user_id, operation, attrs, time) do
    case :mnesia.transaction(fn ->
           :mnesia.write({Event, get_next_index(), user_id, operation, attrs, time})
         end) do
      {:atomic, :ok} -> :ok
      {:aborted, reason} -> {:error, reason}
    end
  end

  @spec get_event(pos_integer() | operation) :: {:ok, [list(keyword())]} | {:error, any()}
  def get_event(user_id) when is_integer(user_id), do: read_from_mnesia(user_id, :_)
  def get_event(operation) when is_atom(operation), do: read_from_mnesia(:_, operation)
  def get_event(_), do: events()
  def events, do: read_from_mnesia(:_, :_)

  defp read_from_mnesia(user_id, operation) do
    case :mnesia.transaction(fn ->
           :mnesia.match_object({Event, :_, user_id, operation, :_, :_})
         end) do
      {:atomic, result} -> {:ok, Enum.map(result, &parse/1)}
      {:aborted, reason} -> {:error, reason}
    end
  end

  defp get_next_index() do
    case :mnesia.transaction(fn -> :mnesia.last(Event) end) do
      {:atomic, :"$end_of_table"} -> 1
      {:atomic, num} -> num + 1
    end
  end

  defp parse({_, event_id, user_id, operation, attrs, time}),
    do: %{event_id: event_id, user_id: user_id, operation: operation, attrs: attrs, time: time}
end
