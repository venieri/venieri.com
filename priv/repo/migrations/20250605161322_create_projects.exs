defmodule Venieri.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :show, :boolean, default: true, null: false
      add :title, :string
      add :slug, :string
      add :description, :string
      add :statement, :text

      timestamps(type: :utc_datetime)
    end

    create index(:projects, [:title])
    create unique_index(:projects, [:slug])
  end
end
