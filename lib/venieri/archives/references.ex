defmodule Venieri.Archives.References do
  @moduledoc """
  The Archives context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Reference

  @doc """
  Returns the list of references.

  ## Examples

      iex> list()
      [%Reference{}, ...]

  """
  def list do
    Repo.all(Reference)
  end

  @doc """
  Gets a single reference.

  Raises `Ecto.NoResultsError` if the Reference does not exist.

  ## Examples

      iex> get!(123)
      %Reference{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Reference, id)

  @doc """
  Creates a reference.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Reference{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Reference{}
    |> Reference.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reference.

  ## Examples

      iex> update(reference, %{field: new_value})
      {:ok, %Reference{}}

      iex> update(reference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Reference{} = reference, attrs) do
    reference
    |> Reference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reference.

  ## Examples

      iex> delete(reference)
      {:ok, %Reference{}}

      iex> delete(reference)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Reference{} = reference) do
    Repo.delete(reference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reference changes.

  ## Examples

      iex> change(reference)
      %Ecto.Changeset{data: %Reference{}}

  """
  def change(%Reference{} = reference, attrs \\ %{}) do
    Reference.changeset(reference, attrs)
  end
end
