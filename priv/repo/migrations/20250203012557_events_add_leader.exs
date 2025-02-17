defmodule Venieri.Repo.Migrations.EventsAddLeader do
  use Ecto.Migration

  def change do
    alter table(:archives_events) do
      add :leader, :string
    end
  end
end
