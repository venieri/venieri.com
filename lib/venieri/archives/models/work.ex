defmodule Venieri.Archives.Models.Work do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.WorkSlug
  alias Venieri.Archives.Models.Tag
  alias Venieri.Archives.Models.WorkTag
  alias Venieri.Archives.Models.WorkMedia
  alias Venieri.Archives.Models.Media

  schema "archives_works" do
    field :size, :string
    field :year, :integer
    field :description, :string
    field :title, :string
    field :slug, WorkSlug.Type
    field :material, :string
    field :show, :boolean, default: true
    field :uploads, {:array, :string}, virtual: true
    belongs_to :project, Project, type: :id, on_replace: :nilify

    many_to_many :tags, Tag, join_through: WorkTag, on_replace: :delete
    many_to_many :media, Media, join_through: WorkMedia, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(work, attrs, _meta \\ []) do
    {year, _} = Date.utc_today() |> Date.year_of_era()
    work
    |> cast(attrs, [:title, :slug, :year, :material, :size, :description, :show, :project_id, :uploads])
    |> validate_required([:title, :year, :show])
    |> validate_number(:year, greater_than: 1964, less_than: year+1)
    # |> foreign_key_constraint(:project_id)
    |> WorkSlug.maybe_generate_slug()
    |> WorkSlug.unique_constraint()
  end
  def changeset_with_media(work, attrs) do
    {year, _} = Date.utc_today() |> Date.year_of_era()
    work
    |> cast(attrs, [:title, :slug, :year, :material, :size, :description, :show, :project_id, :uploads])
    |> validate_required([:title, :year, :show])
    |> validate_number(:year, greater_than: 1964, less_than: year+1)
    |> WorkSlug.maybe_generate_slug()
    |> WorkSlug.unique_constraint()
    |> cast_assoc(:media)
  end

  def changeset_update_media(%Work{} = work, media) do
    work
    |> cast(%{media: media}, [:title, :slug, :year, :material, :size, :description, :show, :project_id, :uploads])
    |> Ecto.Changeset.cast_assoc(
      :media
    )

    # # associate projects to the user
    # |> put_assoc(:media, media)
  end


end

defimpl SEO.OpenGraph.Build, for: Venieri.Archives.Models.Work do
  use VenieriWeb, :verified_routes

  def build(work, conn) do
    SEO.OpenGraph.build(
      detail:
        SEO.OpenGraph.Work.build(
          published_time: work.updated_at,
          author: "Lydia Venieri",
          section: "CreativeWork"
        ),
      image: SEO.OpenGraph.Image.build(
        url:  Venieri.Archives.Works.image_url(work, 480),
        alt: work.title
      ),
      title: work.title,
      description: work.description
    )
  end
end

defimpl SEO.Site.Build, for: Venieri.Archives.Models.Work do
  use VenieriWeb, :verified_routes

  def build(work, conn) do
    # Because of `Phoenix.Param`, structs will assume the key of `:id` when
    # interpolating the struct into the verified route.
    SEO.Site.build(
      url: url(conn, ~p"/work/#{work.id}"),
      title: work.title,
      description: work.description
    )
  end
end

defimpl SEO.Twitter.Build, for: Venieri.Archives.Models.Work do
  def build(work, _conn) do
    SEO.Twitter.build(description: work.description, title: work.title)
  end
end

defimpl SEO.Unfurl.Build, for: Venieri.Archives.Models.Work do
  def build(work, _conn) do
    SEO.Unfurl.build(
      label1: "Reading Time",
      data1: "5 minutes",
      label2: "Published",
      data2: DateTime.to_iso8601(work.updated_at)
    )
  end
end

defimpl SEO.Breadcrumb.Build, for: Venieri.Archives.Models.Work do
  use VenieriWeb, :verified_routes

  def build(work, conn) do
    # Because of `Phoenix.Param`, structs will assume the key of `:id` when
    # interpolating the struct into the verified route.
    SEO.Breadcrumb.List.build([
      %{name: "Works", item: url(conn, ~p"/works")},
      %{name: work.title, item: url(conn, ~p"/works/#{work.id}")}
    ])
  end
end
