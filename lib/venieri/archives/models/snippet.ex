defmodule Venieri.Archives.Models.Snippet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "snippets" do
    field :label, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(snippet, attrs, mets \\ []) do
    snippet
    |> cast(attrs, [:label, :content])
    |> validate_required([:label, :content])
    |> unique_constraint([:label])
  end
end
