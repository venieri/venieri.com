defmodule Venieri.Archives.Models.MediaSlug do
  use EctoAutoslugField.Slug, to: :slug, always_change: true

  def get_sources(changeset, _opts) do
    original_file = Ecto.Changeset.get_field(changeset, :original_file)
    if original_file != nil do
      case Ecto.Changeset.get_field(changeset, :caption) do
        nil ->
            [original_file]
        caption ->
          uuid =  original_file |> String.split("-") |> List.last |> Path.rootname
          [caption, uuid]
      end
    else
      []
    end
  end
end
