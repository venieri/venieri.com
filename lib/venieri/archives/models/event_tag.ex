defmodule Venieri.Archives.Models.EventTag do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Event
  alias Venieri.Archives.Models.Tag

  schema "archives_events_tags" do
    belongs_to(:event, Event)
    belongs_to(:tag, Tag)

    timestamps()
  end

  @required_fields ~w[event_id tag_id]a

  @doc false
  def changeset(event_tag, attrs) do
    event_tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:tag_id)
  end
end
