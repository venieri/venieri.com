defmodule Venieri.Archives.Models.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.Tag
  alias Venieri.Archives.Models.Media
  alias Venieri.Archives.Models.PostTag
  alias Venieri.Archives.Models.PostMedia
  alias Venieri.Archives.Models.PostSlug

  @required_fields ~w(post_date slug title to_show type)a
  @optional_fields ~w(description logline orientation venue location location_url start_date end_date event_url press_release)a

  schema "posts" do
    field :title, :string
    field :type, Ecto.Enum, values: [:article, :event, :other], default: :event
    field :slug, PostSlug.Type
    field :logline, :string
    field :description, :string
    field :post_date, :date
    field :to_show, :boolean, default: true
    field :orientation, :string, default: "auto"

    field :venue, :string
    field :location, :string
    field :location_url, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :event_url, :string
    field :press_release, :string

    many_to_many(:tags, Tag, join_through: PostTag, on_replace: :delete)
    many_to_many(:media, Media, join_through: PostMedia, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs, _extra \\ []) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> PostSlug.maybe_generate_slug()
    |> validate_required(@required_fields)
    |> PostSlug.unique_constraint()
  end
end
