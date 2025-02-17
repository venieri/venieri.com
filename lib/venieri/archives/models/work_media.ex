defmodule Venieri.Archives.Models.WorkMedia do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.Media


  schema "archives_works_media" do
    belongs_to :work, Work
    belongs_to :media, Media

    timestamps()
  end

  @required_fields ~w[work_id media_id]a

  @doc false
  def changeset(work_media, attrs) do
    work_media
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:work_id)
    |> foreign_key_constraint(:media_id)
  end
end
