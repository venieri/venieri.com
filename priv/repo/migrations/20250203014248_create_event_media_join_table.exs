defmodule Venieri.Repo.Migrations.CreateEventMediaJoinTable do
  use Ecto.Migration

  def change do
    create table(:archives_events_media) do
      add :event_id, references(:archives_events, on_delete: :delete_all), null: false
      add :media_id, references(:archives_media, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:archives_events_media, [:event_id])
    create index(:archives_events_media, [:media_id])
  end
end
