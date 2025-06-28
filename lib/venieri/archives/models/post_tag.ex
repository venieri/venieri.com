defmodule Venieri.Archives.Models.PostTag do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  alias Venieri.Archives.Models.Post
  alias Venieri.Archives.Models.Tag

  schema "posts_tags" do
    belongs_to(:post, Post, on_replace: :delete)
    belongs_to(:tag, Tag, on_replace: :delete)
  end

  @required_fields ~w[post_id tag_id]a

  @doc false
  def changeset(post_tag, attrs) do
    post_tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:tag_id)
  end
end
