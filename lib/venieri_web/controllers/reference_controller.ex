defmodule VenieriWeb.ReferenceController do
  use VenieriWeb, :controller

  alias Venieri.Archives.References
  alias Venieri.Archives.Models.Reference

  def index(conn, _params) do
    references = References.list()
    render(conn, :index, references: references)
  end

  def new(conn, _params) do
    changeset = References.change(%Reference{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"reference" => reference_params}) do
    case References.create(reference_params) do
      {:ok, reference} ->
        conn
        |> put_flash(:info, "Reference created successfully.")
        |> redirect(to: ~p"/archives/references/#{reference}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reference = References.get!(id)
    render(conn, :show, reference: reference)
  end

  def edit(conn, %{"id" => id}) do
    reference = References.get!(id)
    changeset = References.change(reference)
    render(conn, :edit, reference: reference, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reference" => reference_params}) do
    reference = References.get!(id)

    case References.update(reference, reference_params) do
      {:ok, reference} ->
        conn
        |> put_flash(:info, "Reference updated successfully.")
        |> redirect(to: ~p"/archives/references/#{reference}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, reference: reference, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reference = References.get!(id)
    {:ok, _reference} = References.delete(reference)

    conn
    |> put_flash(:info, "Reference deleted successfully.")
    |> redirect(to: ~p"/archives/references")
  end
end
