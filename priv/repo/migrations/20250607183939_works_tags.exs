defmodule Venieri.Repo.Migrations.WorksTags do
  use Ecto.Migration

  def change do
    create table(:works_tags) do
      add :work_id, references(:works, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)

      timestamps()
    end

    create index(:works_tags, [:work_id])
    create index(:works_tags, [:tag_id])
  end
end
