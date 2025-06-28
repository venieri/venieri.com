defmodule Venieri.Repo.Migrations.CreateProjectsTags do
  use Ecto.Migration

  def change do
    create table(:projects_tags) do
      add :project_id, references(:projects, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
    end

    create unique_index(:projects_tags, [:project_id, :tag_id])
  end
end
