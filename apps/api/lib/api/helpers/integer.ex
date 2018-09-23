defmodule Api.Helpers.Integer do
  @moduledoc """
  Functions for working with integers.
  """

  @doc """
  Parse integer and return a result tuple. This function wraps the built-in
  `Integer.parse`.

  ## Examples

      iex> Api.Helpers.Integer.parse(10)
      {:ok, 10}

      iex> Api.Helpers.Integer.parse("10")
      {:ok, 10}

      iex> Api.Helpers.Integer.parse("10a")
      {:error, :invalid}

      iex> Api.Helpers.Integer.parse("invalid")
      {:error, :invalid}

      iex> Api.Helpers.Integer.parse(nil)
      {:error, :invalid}
  """
  @spec parse(integer() | String.t()) :: {:ok, integer()} | {:error, :invalid}
  def parse(value) when is_integer(value), do: {:ok, value}

  def parse(value) when is_binary(value) do
    with {integer, ""} <- Integer.parse(value) do
      {:ok, integer}
    else
      _ -> {:error, :invalid}
    end
  end

  def parse(_value), do: {:error, :invalid}
end
