defmodule Venieri.Repo.Migrations.ReferencesAddEdition do
  use Ecto.Migration

    def change do
      alter table(:archives_references) do
        add :edition, :string
      end
    end
  end
