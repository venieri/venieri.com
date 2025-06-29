defmodule Venieri.Repo.Migrations.ProjectsMedia do
  use Ecto.Migration

  def change do
    create table(:projects_media) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :media_id, references(:media, on_delete: :delete_all)

      timestamps()
    end

    create index(:projects_media, [:project_id])
    create index(:projects_media, [:media_id])
  end
end
