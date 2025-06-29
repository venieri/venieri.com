defmodule Venieri.Archives.Models.EventSlug do
  use EctoAutoslugField.Slug, to: :slug
  alias Venieri.Archives.Models.Event

  def get_sources(changeset, _opts) do
    case Ecto.Changeset.get_field(changeset, :start_date) do
      nil ->
        [:title, :venue]

      start_date ->
        [:title, :venue, start_date |> NaiveDateTime.to_date() |> Date.to_iso8601()]
    end
  end

  def build_slug(sources, changeset) do
    slug =
      sources
      |> super(changeset)

    Venieri.Repo.get_by(Event, slug: slug)
    |> case do
      nil ->
        slug

      _ ->
        {:ok, id} = Snowflake.next_id()
        slug <> "-" <> Slug.slugify(id |> Integer.to_string(36))
    end
  end
end
