defmodule Venieri.Repo.Migrations.EventsAlterLeader do
  use Ecto.Migration

  def change do
    alter table(:archives_events) do
      modify  :leader, :text
    end
  end
end
