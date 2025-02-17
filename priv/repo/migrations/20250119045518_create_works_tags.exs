defmodule Venieri.Repo.Migrations.CreateWorksTags do
  use Ecto.Migration

  def change do
    create table(:archives_works_tags) do
      add :work_id, references(:archives_works, on_delete: :delete_all), null: false
      add :tag_id, references(:archives_tags, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:archives_works_tags, [:work_id, :tag_id])
  end
end
