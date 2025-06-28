defmodule Venieri.Archives.Models.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Venieri.Archives.Models.Event
  alias Venieri.Archives.Models.EventTag
  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.ProjectTag
  alias Venieri.Archives.Models.Post
  alias Venieri.Archives.Models.PostTag
  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.WorkTag

  schema "tags" do
    field(:label, :string)

    many_to_many(:projects, Project, join_through: ProjectTag, on_replace: :delete)
    many_to_many(:posts, Post, join_through: PostTag, on_replace: :delete)
    # many_to_many(:works, Work, join_through: WorkTag, on_replace: :delete)
    # # many_to_many :media, Media, join_through: MediaTag, on_replace: :delete
    # many_to_many(:events, Event, join_through: EventTag, on_replace: :delete)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs, _meta \\ []) do
    tag
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end
end
