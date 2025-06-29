defmodule Venieri.Archives.Models.Counter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.LabelSlug

  schema "counters" do
    field :label, :string, virtual: true
    field :slug, LabelSlug.Type
    field :count, :integer, default: 0
  end

  @doc false
  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:label, :slug, :count])
    |> LabelSlug.maybe_generate_slug()
    |> validate_required([:slug, :count])
    |> LabelSlug.unique_constraint()
  end
end
