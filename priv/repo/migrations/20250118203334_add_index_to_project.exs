defmodule Venieri.Repo.Migrations.AddIndexToProject do
  use Ecto.Migration

  def change do
    create unique_index(:archives_projects, [:title])
    create unique_index(:archives_projects, [:slug])
  end
end
