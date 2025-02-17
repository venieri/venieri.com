defmodule Venieri.Repo.Migrations.DropArchivesWorksProjectIdFkey do
  use Ecto.Migration

  def change do
    drop index(:archives_works, [:project_id])
  end
end
