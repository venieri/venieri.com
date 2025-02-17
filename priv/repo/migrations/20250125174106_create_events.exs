defmodule Venieri.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:archives_events) do
      add :title, :string
      add :slug, :string
      add :description, :text
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :venue, :text
      add :show, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:archives_events, [:slug])
  end
end
