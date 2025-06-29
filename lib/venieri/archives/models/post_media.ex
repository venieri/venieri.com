defmodule Venieri.Archives.Models.PostMedia do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Post
  alias Venieri.Archives.Models.Media

  schema "posts_media" do
    belongs_to(:post, Post)
    belongs_to(:media, Media)
  end

  @required_fields ~w[post_id media_id]a

  @doc false
  def changeset(post_media, attrs) do
    post_media
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:media_id)
  end
end
