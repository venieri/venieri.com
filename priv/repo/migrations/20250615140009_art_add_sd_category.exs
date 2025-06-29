defmodule Venieri.Repo.Migrations.ArtAddSdCategory do
  use Ecto.Migration

  def change do
    alter table(:works) do
      add :sd_category, :string
      add :poster_id, references(:media, on_delete: :nilify_all)
    end
  end
end
