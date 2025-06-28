defmodule Venieri.Repo.Migrations.PostAddEventFields do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      add :type, :string, default: "event"
      add :venue, :string
      add :location, :text
      add :location_url, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :event_url, :string
      add :press_release, :string
      modify :logline, :text
      modify :description, :text
    end
  end

  def down do
    alter table(:posts) do
      remove :type, :string, default: "event"
      remove :venue, :string
      remove :location, :text
      remove :location_url, :string
      remove :start_date, :utc_datetime
      remove :end_date, :utc_datetime
      remove :event_url, :string
      remove :press_release, :string
    end
  end
end
