defmodule Venieri.Archives.Models.MediaSlug do
  use EctoAutoslugField.Slug, to: :slug, always_change: false

  def get_sources(changeset, _opts) do
    uploaded_file = Ecto.Changeset.get_field(changeset, :uploaded_file)
    external_uri = Ecto.Changeset.get_field(changeset, :external_uri)
    caption = Ecto.Changeset.get_field(changeset, :caption)

    cond do
      caption != nil ->
        [caption]

      uploaded_file != nil ->
        [uploaded_file |> String.split("-") |> List.last() |> Path.rootname()]

      external_uri != nil ->
        [external_uri]

      true ->
        []
    end
  end

  def build_slug(sources, changeset) do
    dbg({sources, changeset}, limit: :infinity)

    slug =
      sources
      |> super(changeset)

    case fetch(slug) do
      nil ->
        slug

      %Venieri.Archives.Models.Media{slug: slug} ->
        count = Venieri.Archives.Counters.inc(slug)
        # if count == 1, do: count + 1, else: count
        "#{slug}_#{count}"
    end
  end

  def fetch(slug), do: Venieri.Repo.get_by(Venieri.Archives.Models.Media, slug: slug)
end

# def build_slug2(sources, changeset) do
#   dbg({sources, changeset}, limit: :infinity)

#   slug =
#     sources
#     |> super(changeset)

#   with %Venieri.Archives.Models.Media{slug: slug} <- fetch(slug),
#        %{"base" => _base, "count" => count} <-
#          Regex.named_captures(~r/(?<base>[\w-]+)_(?<count>\d+)/, slug) do
#     "#{slug}_#{Stream.to_integer(count) + 1}"
#   else
#     _ -> slug
#   end
# end
