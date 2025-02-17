defmodule VenieriWeb.AdminTagLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Tag,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Tag.changeset/3,
      create_changeset: &Venieri.Archives.Models.Tag.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      name: Venieri.PubSub,
      topic: "tags",
      event_prefix: "tag_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Tag"

  @impl Backpex.LiveResource
  def plural_name, do: "Tags"

  @impl Backpex.LiveResource
  def fields do
    [
      label: %{
        module: Backpex.Fields.Text,
        label: "Label",
        searchable: true
      }
    ]
  end
end
