defmodule Venieri.Archives.Works do
  @moduledoc """
  The Works context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Media
  alias Venieri.Archives.Models.Work

  @doc """
  Returns the list of works.

  ## Examples

      iex> list()
      [%Work{}, ...]

  """
  def list do
    Repo.all(Work)
  end

  @doc """
  Gets a single work.

  Raises `Ecto.NoResultsError` if the Work does not exist.

  ## Examples

      iex> get!(123)
      %Work{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Work, id)

  @doc """
  Creates a work.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Work{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Work{}
    |> Work.changeset(attrs)
    |> Repo.insert()
  end

  def dup_slug?(changeset) do
    # Repo.exists?(from w in Work, where: w.slug == ^cs.changes.slug)
    Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
    |> Map.has_key?(:slug)
    |> dbg()
  end

  @doc """
  Updates a work.

  ## Examples

      iex> update(work, %{field: new_value})
      {:ok, %Work{}}

      iex> update(work, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Work{} = work, attrs) do
    work
    |> Work.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a work.

  ## Examples

      iex> delete(work)
      {:ok, %Work{}}

      iex> delete(work)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Work{} = work) do
    Repo.delete(work)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work changes.

  ## Examples

      iex> change(work)
      %Ecto.Changeset{data: %Work{}}

  """
  def change(%Work{} = work, attrs \\ %{}) do
    Work.changeset(work, attrs)
  end


  def get_media(%Work{} = work) do
    work
    |> Repo.preload(:media)
    |> then(& &1.media)
  end

  def get_media_poster(%Work{} = work) do
    work
    |> get_media()
    |> case do
      [] -> nil
      media_array -> media_array |> hd
    end
  end

  def is_media_poster_vertical?(%Work{} = work) do
    work
    |> get_media_poster()
    |> then(&(&1.width < &1.height))
  end

  def image_url(%Work{} = work, width) do
    work
    |> get_media_poster()
    |> case do
      nil -> ""
      media -> Media.url(media, width)
    end
  end

end
