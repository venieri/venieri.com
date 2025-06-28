defmodule Venieri.Archives.Models.WorkSlug do
  use EctoAutoslugField.Slug, to: :slug

  alias Venieri.Archives.Projects
  alias Venieri.Archives.Models.Work

  def get_sources(changeset, _opts) do
    basic_fields = [:title, :year]

    case Ecto.Changeset.get_field(changeset, :project_id) do
      nil ->
        basic_fields

      project_id ->
        project = Projects.get!(project_id)
        [project.slug | basic_fields]
    end
  end

  def build_slug(sources, changeset) do
    slug =
      sources
      |> super(changeset)

    Venieri.Repo.get_by(Work, slug: slug)
    |> case do
      nil ->
        slug

      _ ->
        {:ok, id} = Snowflake.next_id()
        slug <> "-" <> Slug.slugify(id |> Integer.to_string(36))
    end
  end
end
