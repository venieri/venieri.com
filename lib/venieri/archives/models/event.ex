defmodule Venieri.Archives.Models.Event do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.EventSlug
  alias Venieri.Archives.Models.Tag
  alias Venieri.Archives.Models.EventTag
  alias Venieri.Archives.Models.Media
  alias Venieri.Archives.Models.EventMedia

  @derive {
    Flop.Schema,
    filterable: [:title, :start_date],
    sortable: [:start_date, :slug],
    default_order: %{
      order_by: [:start_date],
      order_directions: [:desc]
    },
    default_limit: 6
  }

  schema "archives_events" do
    field(:description, :string)
    field(:title, :string)
    field(:leader, :string)
    field(:slug, EventSlug.Type)
    field(:start_date, :utc_datetime)
    field(:end_date, :utc_datetime)
    field(:venue, :string)
    field(:show, :boolean, default: true)
    field(:orientation, :string, default: "auto")
    many_to_many(:tags, Tag, join_through: EventTag, on_replace: :delete)
    many_to_many(:media, Media, join_through: EventMedia, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs, _meta \\ []) do
    event
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :start_date,
      :leader,
      :end_date,
      :venue,
      :show,
      :orientation
    ])
    |> validate_required([:title, :start_date])
    |> EventSlug.maybe_generate_slug()
    |> EventSlug.unique_constraint()
  end
end
