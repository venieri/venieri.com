defmodule Venieri.Archives.Posts do
  alias Venieri.Archives.Models.Post

  alias Venieri.Repo

  alias Venieri.Archives.Media

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list()
      [%Post{}, ...]

  """
  def list do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get
      !(123)
      %Post{}

      iex> get
      !(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create
      (%{field: value})
      {:ok, %Post{}}

      iex> create
      (%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> dbg()
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update
      (post, %{field: new_value})
      {:ok, %Post{}}

      iex> update
      (post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete
      (post)
      {:ok, %Post{}}

      iex> delete
      (post)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change
      (post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def by_tag(%Venieri.Archives.Models.Tag{} = tag), do: by_tag(tag.label)

  def by_tag(tag_label) when is_binary(tag_label) do
    posts =
      Repo.get_by(Venieri.Archives.Models.Tag, label: tag_label)
      |> Repo.preload(:posts)
      |> then(& &1.posts)
      |> Enum.map(&Repo.preload(&1, :media))
  end

  def image_url(%Post{} = post, width) do
    post.media
    |> case do
      [] -> ""
      media -> Media.url(media |> hd)
    end
  end

  # |> Enum.group_by(&VenieriWeb.Components.Helpers.fmt_year(&1.start_date), & &1)
  # |> Enum.sort_by(&elem(&1, 0), :desc)
end
