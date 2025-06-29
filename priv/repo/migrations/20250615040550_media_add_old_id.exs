defmodule Venieri.Repo.Migrations.MediaAddOldId do
  use Ecto.Migration

  def change do
    alter table(:media) do
      add :old_id, :integer
    end
  end
end
