defmodule Venieri.Repo.Migrations.CreateProjectsTags do
  use Ecto.Migration

  def change do
    create table(:archives_projects_tags) do
      add :project_id, references(:archives_projects, on_delete: :delete_all), null: false
      add :tag_id, references(:archives_tags, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:archives_projects_tags, [:project_id, :tag_id])
  end
end
