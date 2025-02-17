defmodule Venieri.Repo.Migrations.CreateArchivesReferences do
  use Ecto.Migration

  def change do
    create table(:archives_references) do
      add :title, :string
      add :description, :text
      add :publication_date, :date
      add :publication, :string
      add :authors, :string
      add :article_url, :string
      add :uploaded_file, :string

      timestamps(type: :utc_datetime)
    end
  end
end
