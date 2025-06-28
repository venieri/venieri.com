defmodule Venieri.Archives.Counters do
  alias Venieri.Archives.Models.Counter
  alias Venieri.Repo

  def list() do
    Counter
    # |> group_by([c], c.slug)
    # |> select([c], {c.slug, max(c.count)})
    |> Repo.all()
  end

  @doc """
  Creates a tag.

  ## Examples

      iex> incr(type)
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def inc(label) do
    # with {:ok, tag = %Counter{}} <-
    #        %Counter{}
    #        |> Counter.changeset(%{})
    #        |> Repo.insert() do
    #   tag.id
    # end
    #
    with {:ok, counter = %Counter{}} <-
           %Counter{}
           |> Counter.changeset(%{label: label, count: 1})
           |> Repo.insert(
             on_conflict: [inc: [count: 1]],
             conflict_target: :slug
           ) do
      Repo.get_by!(Counter, slug: counter.slug).count
    end
    |> dbg()
  end
end
