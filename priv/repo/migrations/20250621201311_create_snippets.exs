defmodule Venieri.Repo.Migrations.CreateSnippets do
  use Ecto.Migration

  def change do
    create table(:snippets) do
      add :label, :string
      add :content, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:snippets, [:label])
  end
end
