defmodule Venieri.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:archives_projects) do
      add :title, :string
      add :slug, :string
      add :description, :text
      add :statement, :text
      add :show, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
