defmodule Venieri.Repo.Migrations.EventsLayout do
  use Ecto.Migration

  def change do
    alter table(:archives_events) do
      add :orientation, :string, default: "auto"
    end
  end
end
