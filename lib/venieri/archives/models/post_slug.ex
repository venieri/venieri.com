defmodule Venieri.Archives.Models.PostSlug do
  use EctoAutoslugField.Slug, to: :slug
  alias Venieri.Archives.Models.Post

  def get_sources(_changeset, _opts) do
    [:title, :post_date, :venue]
    # case Ecto.Changeset.get_field(changeset, :post_date) do
    #   nil ->
    #     [:title]

    #   post_date ->
    #     [:title, :post_date, :logline]
    # end
  end

  def build_slug(sources, changeset) do
    slug =
      sources
      |> super(changeset)

    # Venieri.Repo.get_by(Post, slug: slug)
    # |> case do
    #   nil ->
    #     slug

    #   _ ->
    #     {:ok, id} = Snowflake.next_id()
    #     slug <> "-" <> Slug.slugify(id |> Integer.to_string(36))
    # end
  end
end
