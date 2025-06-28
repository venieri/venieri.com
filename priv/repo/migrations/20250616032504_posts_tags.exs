defmodule Venieri.Repo.Migrations.PostsTags do
  use Ecto.Migration

  def change do
    create table(:posts_tags) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create index(:posts_tags, [:post_id])
    create index(:posts_tags, [:tag_id])
  end
end
