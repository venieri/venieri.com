defmodule Venieri.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:archives_tags) do
      add :label, :string

      timestamps(type: :utc_datetime)
    end

    create index(:archives_tags, [:label])
  end
end
