defmodule Venieri.Archives.Models.LabelSlug do
  use EctoAutoslugField.Slug, from: :label, to: :slug
end
