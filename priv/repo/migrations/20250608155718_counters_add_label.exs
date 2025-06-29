defmodule Venieri.Repo.Migrations.CountersAddLabel do
  use Ecto.Migration

  def change do
    alter table(:counters) do
      add :slug, :string
      add :count, :integer, default: 0
    end

    create unique_index(:counters, [:slug])
  end
end
