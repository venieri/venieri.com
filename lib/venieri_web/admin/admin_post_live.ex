defmodule VenieriWeb.AdminPostLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Blog.Post,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Blog.Post.changeset/3,
      create_changeset: &Venieri.Blog.Post.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      name: Venieri.PubSub,
      topic: "posts",
      event_prefix: "post_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Post"

  @impl Backpex.LiveResource
  def plural_name, do: "Posts"

  @impl Backpex.LiveResource
  def fields do
    [
      title: %{
        module: Backpex.Fields.Text,
        label: "Title"
      },
      views: %{
        module: Backpex.Fields.Number,
        label: "Views"
      }
    ]
  end
end