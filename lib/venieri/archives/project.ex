defmodule Venieri.Archives.ProjectX do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.ProjectTag
  alias Venieri.Archives.Tag
  alias Venieri.Archives.Fields.TitleSlug

  schema "projects" do
    field :to_show, :boolean, default: true
    field :title, :string
    field :slug, TitleSlug.Type
    field :description, :string
    field :statement, :string

    many_to_many(:tags, Tag, join_through: ProjectTag, on_replace: :delete)

    timestamps(type: :utc_datetime)
  end

  def changeset(project, attrs) do
    project
    |> cast(attrs, [:to_show, :title, :slug, :description, :statement])
    |> validate_required([:to_show, :title, :slug])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end

  def update_changeset(post, attrs, _metadata \\ []) do
    post
    |> changeset(attrs)
  end

  def create_changeset(post, attrs, _metadata \\ []) do
    post
    |> changeset(attrs)
  end
end
