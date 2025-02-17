defmodule Venieri.Repo.Migrations.CreateEventTags do
  use Ecto.Migration

  def change do
    create table(:archives_events_tags) do
      add :event_id, references(:archives_events, on_delete: :delete_all), null: false
      add :tag_id, references(:archives_tags, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:archives_events_tags, [:event_id, :tag_id])
  end
end
