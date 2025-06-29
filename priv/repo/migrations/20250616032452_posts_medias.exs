defmodule Venieri.Repo.Migrations.PostsMedia do
  use Ecto.Migration

  def change do
    create table(:posts_media) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :media_id, references(:media, on_delete: :delete_all)
    end

    create index(:posts_media, [:post_id])
    create index(:posts_media, [:media_id])
  end
end
