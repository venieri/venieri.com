defmodule Venieri.Archives.Models.ProjectWork do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.Work

  schema "projects_works" do
    belongs_to(:project, Project)
    belongs_to(:work, Work)
  end

  @required_fields ~w[project_id work_id]a

  @doc false
  def changeset(project_work, attrs) do
    project_work
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:project_id)
    |> foreign_key_constraint(:work_id)
  end
end
