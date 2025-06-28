defmodule Venieri.Repo.Migrations.ReferencesCreate do
  use Ecto.Migration

  def change do
    create table(:references) do
      add :title, :string
      add :description, :text
      add :edition, :string
      add :publication_date, :date
      add :publication, :string
      add :authors, :string
      add :article_url, :string
      add :uploaded_file, :string

      timestamps(type: :utc_datetime)
    end
  end
end
