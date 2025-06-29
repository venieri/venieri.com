defmodule Venieri.Repo.Migrations.CreateMediaTable do
  use Ecto.Migration

  def change do
    create table(:media) do
      add :type, :string
      add :caption, :string
      add :slug, :string
      add :height, :integer
      add :width, :integer
      add :uploaded_file, :string
      add :external_uri, :string
      add :embeded_html, :text
      add :meta_data, :map

      timestamps(type: :utc_datetime)
    end

    create unique_index(:media, [:slug])
  end
end
