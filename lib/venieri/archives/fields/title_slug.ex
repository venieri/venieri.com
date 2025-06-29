defmodule Venieri.Archives.Fields.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
