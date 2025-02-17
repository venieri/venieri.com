defmodule Venieri.Repo.Migrations.CreateMedia do
  use Ecto.Migration

  def change do
    create table(:archives_media) do
      add :caption, :string
      add :slug, :string
      add :exernal_ref, :text
      add :height, :integer
      add :width, :integer
      add :old_id, :integer
      add :original_file, :string
      add :type, :string
      add :meta_data, :map

      timestamps(type: :utc_datetime)
    end

    create unique_index(:archives_media, [:slug])
  end
end
