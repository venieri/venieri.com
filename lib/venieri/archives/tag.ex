defmodule Venieri.Archives.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.ProjectTag
  alias Venieri.Archives.Project

  schema "tags" do
    field :label, :string
    many_to_many(:projects, Project, join_through: ProjectTag, on_replace: :delete)
    timestamps(type: :utc_datetime)
  end

  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:label])
    |> validate_required([:label])
  end

  def update_changeset(post, attrs, _metadata \\ []) do
    post
    |> changeset(attrs)
  end

  def create_changeset(post, attrs, _metadata \\ []) do
    post
    |> changeset(attrs)
  end
end
