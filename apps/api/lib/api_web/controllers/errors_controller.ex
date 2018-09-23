defmodule ApiWeb.ErrorsController do
  use Phoenix.Controller

  def call(conn, {:error, :invalid}) do
    conn
    |> put_status(400)
    |> json(ApiWeb.ErrorView.render("400.json"))
    |> halt()
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> json(ApiWeb.ErrorView.render("404.json"))
    |> halt()
  end

  def call(conn, {:error, %Ecto.Changeset{}}) do
    conn
    |> put_status(422)
    |> json(ApiWeb.ErrorView.render("422.json"))
    |> halt()
  end
end
