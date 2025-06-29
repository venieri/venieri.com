defmodule Venieri.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Inventory.Piece

  @doc """
  Returns the list of piece.

  ## Examples

      iex> list_piece()
      [%Piece{}, ...]

  """
  def list_piece do
    Repo.all(Piece)
  end

  @doc """
  Gets a single piece.

  Raises `Ecto.NoResultsError` if the Piece does not exist.

  ## Examples

      iex> get_piece!(123)
      %Piece{}

      iex> get_piece!(456)
      ** (Ecto.NoResultsError)

  """
  def get_piece!(id), do: Repo.get!(Piece, id)

  @doc """
  Creates a piece.

  ## Examples

      iex> create_piece(%{field: value})
      {:ok, %Piece{}}

      iex> create_piece(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_piece(attrs) do
    %Piece{}
    |> Piece.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a piece.

  ## Examples

      iex> update_piece(piece, %{field: new_value})
      {:ok, %Piece{}}

      iex> update_piece(piece, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_piece(%Piece{} = piece, attrs) do
    piece
    |> Piece.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a piece.

  ## Examples

      iex> delete_piece(piece)
      {:ok, %Piece{}}

      iex> delete_piece(piece)
      {:error, %Ecto.Changeset{}}

  """
  def delete_piece(%Piece{} = piece) do
    Repo.delete(piece)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking piece changes.

  ## Examples

      iex> change_piece(piece)
      %Ecto.Changeset{data: %Piece{}}

  """
  def change_piece(%Piece{} = piece, attrs \\ %{}) do
    Piece.changeset(piece, attrs)
  end
end
