defmodule Venieri.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :slug, :string
      add :logline, :string
      add :description, :string
      add :post_date, :date
      add :to_show, :boolean, default: false, null: false
      add :orientation, :string

      timestamps(type: :utc_datetime)
    end
  end
end
