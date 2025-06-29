defmodule Venieri.Archives.Models.ProjectMedia do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.Media

  schema "projects_media" do
    belongs_to(:project, Project)
    belongs_to(:media, Media)
  end

  @required_fields ~w[project_id media_id]a

  @doc false
  def changeset(project_media, attrs) do
    project_media
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:media_id)
  end
end
