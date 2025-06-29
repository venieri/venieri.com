defmodule Venieri.Archives.Models.WorkTag do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.Tag

  schema "works_tags" do
    belongs_to(:work, Work)
    belongs_to(:tag, Tag)

    timestamps()
  end

  @required_fields ~w[work_id tag_id]a

  @doc false
  def changeset(work_tag, attrs) do
    work_tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:work_id)
    |> foreign_key_constraint(:tag_id)
  end
end
