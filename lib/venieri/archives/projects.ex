defmodule Venieri.Archives.Projects do
  @moduledoc """
  The Archives context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Works

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list()
      [%Project{}, ...]

  """
  def list do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get!(123)
      %Project{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Project{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete(project)
      {:ok, %Project{}}

      iex> delete(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end

  def get_artworks(%Project{} = project) do
    project
    |> Repo.preload(:works)
    |> then(& &1.works)
  end

  def get_artwork(%Project{} = project) do
    project
    |> get_artworks()
    |> case do
      [] -> nil
      works_array -> works_array |> hd
    end
  end

  def image_url(%Project{} = project, width) do
    project
    |> get_artwork()
    |> case do
      nil -> ""
      artwork -> Works.image_url(artwork, width)
    end
  end
end
