defmodule Venieri.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :label, :string

      timestamps(type: :utc_datetime)
    end

    create index(:tags, [:label])
  end
end
