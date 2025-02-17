defmodule Venieri.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blog_posts" do
    field :title, :string
    field :views, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs, meta \\ []) do
    post
    |> cast(attrs, [:title, :views])
    |> validate_required([:title, :views])
  end
end
