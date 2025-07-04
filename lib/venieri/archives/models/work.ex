defmodule Venieri.Archives.Models.Work do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.WorkSlug
  alias Venieri.Archives.Models.Tag
  alias Venieri.Archives.Models.WorkTag
  alias Venieri.Archives.Models.WorkMedia
  alias Venieri.Archives.Models.Media

  @optional_fields ~W(description medium size uploads project_id poster_id)a
  @required_fields ~W(show slug title year)a

  schema "works" do
    field(:title, :string)
    field(:description, :string)
    field(:medium, :string)
    # field(:sd_category, :string)
    field(:show, :boolean, default: true)
    field(:size, :string)
    field(:slug, WorkSlug.Type)
    field(:year, :integer)
    field(:uploads, {:array, :string}, virtual: true)
    belongs_to :poster, Media
    belongs_to :project, Project

    many_to_many(:tags, Tag, join_through: WorkTag, on_replace: :delete)
    many_to_many(:media, Media, join_through: WorkMedia, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(work, attrs, _meta \\ []) do
    work
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> WorkSlug.maybe_generate_slug()
    |> validate_required(@required_fields)
    |> validate_year()
    # |> foreign_key_constraint(:project_id)
    |> WorkSlug.unique_constraint()

    # |> maybe_assoc_media()
  end

  def validate_year(changeset) do
    {year, _} = Date.utc_today() |> Date.year_of_era()

    changeset
    |> validate_number(:year, greater_than: 1964, less_than: year + 1)
  end

  def maybe_assoc_media(changeset) do
    changeset
    |> Ecto.Changeset.get_field(:media)
    |> case do
      nil -> changeset
      _ -> changeset |> cast_assoc(:media)
    end
  end
end
