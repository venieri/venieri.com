defmodule Venieri.Archives.Events do
  @moduledoc """
  The Archives context.
  """

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list()
      [%Event{}, ...]

  """
  def list(opts) do
    [paging: [offset: offset, limit: limit]] = Keyword.validate!(opts, [paging: [offset: 0, limit: 10]])
    Event
    |> where([e], e.show == true)
    |> order_by([e], [desc: e.start_date])
    |> limit([_], ^limit)
    |> offset([_], ^offset)
    |> Repo.all
  end

  def list() do
    Repo.all(Event)
  end

  def page(params \\ %{}), do: Flop.validate_and_run(Event, params, for: Event)

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get!(123)
      %Event{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Event{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete(event)
      {:ok, %Event{}}

      iex> delete(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def events_by_tag(tag) do
    solo_shows =
      Repo.get_by(Venieri.Archives.Models.Tag, label: tag)
      |> Repo.preload(:events)
      |> then(& &1.events)
      |> Enum.map(&Repo.preload(&1, :media))
      |> Enum.group_by(&VenieriWeb.Components.Helpers.fmt_year(&1.start_date), & &1)
      |> Enum.sort_by(&elem(&1, 0), :desc)
  end

  def get_media(%Event{} = event) do
    event
    |> Repo.preload(:media)
    |> then(& &1.media)
  end

  def get_media_poster(%Event{} = event) do
    event
    |> get_media()
    |> case do
      [] -> nil
      media_array -> media_array |> hd
    end
  end

  def is_media_poster_horizontal?(%Event{} = event) do
    event
    |> get_media_poster()
    |> then(&(&1.width >= &1.height))
  end

  def image_url(%Event{} = event, width) do
    event
    |> get_media_poster()
    |> case do
      nil -> ""
      media -> media.slug <> "-#{width}.avif"
    end
  end
end
