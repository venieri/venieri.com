defmodule Venieri.Repo.Migrations.CreateWorks do
  use Ecto.Migration

  def change do
    create table(:archives_works) do
      add :title, :string
      add :slug, :string
      add :year, :integer
      add :material, :string
      add :size, :string
      add :description, :text
      add :show, :boolean, default: false, null: false
      add :project_id, references(:archives_projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:archives_works, [:project_id])
    create unique_index(:archives_works, [:slug])
  end
end
