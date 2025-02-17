defmodule Venieri.Archives.Tags do
  @moduledoc """
  The Archive context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list()
      [%Tag{}, ...]

  """
  def list do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get!(123)
      %Tag{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Tag{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tag.

  ## Examples

      iex> delete(tag)
      {:ok, %Tag{}}

      iex> delete(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change(tag)
      %Ecto.Changeset{data: %Tag{}}

  """
  def change(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end
end
