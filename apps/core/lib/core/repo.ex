defmodule Core.Repo do
  use Ecto.Repo, otp_app: :core

  @type select_result_t(t) :: {:ok, t} | {:error, :not_found}
  @type modify_result_t(t) :: {:ok, t} | {:error, Ecto.Changeset.t()}

  @spec get_record(queryable :: atom() | Ecto.Query.t(), id :: pos_integer()) :: select_result_t(atom())
  def get_record(queryable, id) when is_integer(id) do
    case get(queryable, id) do
      nil -> {:error, :not_found}
      record -> {:ok, record}
    end
  end
end
