defmodule Venieri.Repo.Migrations.CreateWorks do
  use Ecto.Migration

  def change do
    create table(:works) do
      add :title, :string
      add :description, :text
      add :medium, :string
      add :show, :boolean, default: true, null: false
      add :size, :string
      add :slug, :string
      add :year, :integer

      add :project_id, references(:projects, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:works, [:project_id])
    create unique_index(:works, [:slug])
  end
end
