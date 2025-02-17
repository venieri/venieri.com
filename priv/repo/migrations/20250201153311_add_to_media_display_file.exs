defmodule Venieri.Repo.Migrations.AddToMediaDisplayFile do
  use Ecto.Migration

  def change do
    alter table(:archives_media) do
      add :display_file, :string
    end
  end
end
