defmodule Venieri.Archives.Snippets do
  @moduledoc """
  The Archives context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Snippet

  @doc """
  Returns the list of snippets.

  ## Examples

      iex> list()
      [%Snippet{}, ...]

  """
  def list() do
    Repo.all(Snippet)
  end

  @doc """
  Gets a single snippet.

  Raises `Ecto.NoResultsError` if the Snippet does not exist.

  ## Examples

      iex> get!(123)
      %Snippet{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id) do
    Repo.get_by!(Snippet, id: id)
  end

  @doc """
  Gets a single snippet.

  Raises `Ecto.NoResultsError` if the Snippet does not exist.

  ## Examples

      iex> get_by(label: "bio")
      %Snippet{}

      iex> get_by!(label: "No Such Snippet")
      ** (Ecto.NoResultsError)

  """
  def get_by(condition) do
    Repo.get_by(Snippet, condition)
  end

  @doc """
  Creates a snippet.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Snippet{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) do
    with {:ok, snippet = %Snippet{}} <-
           %Snippet{}
           |> Snippet.changeset(attrs)
           |> Repo.insert() do
      {:ok, snippet}
    end
  end

  @doc """
  Updates a snippet.

  ## Examples

      iex> update(snippet, %{field: new_value})
      {:ok, %Snippet{}}

      iex> update(snippet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Snippet{} = snippet, attrs) do
    with {:ok, snippet = %Snippet{}} <-
           snippet
           |> Snippet.changeset(attrs)
           |> Repo.update() do
      {:ok, snippet}
    end
  end

  @doc """
  Deletes a snippet.

  ## Examples

      iex> delete(snippet)
      {:ok, %Snippet{}}

      iex> delete(snippet)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Snippet{} = snippet) do
    with {:ok, snippet = %Snippet{}} <-
           Repo.delete(snippet) do
      {:ok, snippet}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking snippet changes.

  ## Examples

      iex> change(snippet)
      %Ecto.Changeset{data: %Snippet{}}

  """
  def change(%Snippet{} = snippet, attrs \\ %{}) do
    Snippet.changeset(snippet, attrs)
  end
end
