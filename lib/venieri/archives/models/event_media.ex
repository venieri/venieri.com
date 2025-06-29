defmodule Venieri.Archives.Models.EventMedia do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Event
  alias Venieri.Archives.Models.Media

  schema "archives_events_media" do
    belongs_to(:event, Event)
    belongs_to(:media, Media)

    timestamps()
  end

  @required_fields ~w[event_id media_id]a

  @doc false
  def changeset(event_media, attrs) do
    event_media
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:media_id)
  end
end
