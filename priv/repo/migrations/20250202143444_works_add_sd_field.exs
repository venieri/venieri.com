defmodule Venieri.Repo.Migrations.WorksAddSdField do
  use Ecto.Migration

  def change do
    alter table(:archives_works) do
      add :sd_type, :string
    end
  end
end
