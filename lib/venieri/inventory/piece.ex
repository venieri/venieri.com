defmodule Venieri.Inventory.Piece do
  use Ecto.Schema
  import Ecto.Changeset

  schema "piece" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(piece, attrs) do
    piece
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
