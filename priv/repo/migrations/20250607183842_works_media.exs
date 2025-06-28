defmodule Venieri.Repo.Migrations.WorksMedia do
  use Ecto.Migration

  def change do
    create table(:works_media) do
      add :work_id, references(:works, on_delete: :delete_all)
      add :media_id, references(:media, on_delete: :delete_all)

      timestamps()
    end

    create index(:works_media, [:work_id])
    create index(:works_media, [:media_id])
  end
end
