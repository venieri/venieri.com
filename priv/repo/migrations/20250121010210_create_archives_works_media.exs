defmodule Venieri.Repo.Migrations.CreateArchivesWorksMedia do
  use Ecto.Migration

  def change do
    create table(:archives_works_media) do
      add :work_id, references(:archives_works, on_delete: :delete_all), null: false
      add :media_id, references(:archives_media, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:archives_works_media, [:work_id])
    create index(:archives_works_media, [:media_id])
  end
end
