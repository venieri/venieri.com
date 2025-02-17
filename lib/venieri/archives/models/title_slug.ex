defmodule Venieri.Archives.Models.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
