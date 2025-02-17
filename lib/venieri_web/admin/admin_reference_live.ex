defmodule VenieriWeb.AdminReferenceLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Reference,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Reference.changeset/3,
      create_changeset: &Venieri.Archives.Models.Reference.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      name: Venieri.PubSub,
      topic: "references",
      event_prefix: "reference_"
    ]

  @impl Backpex.LiveResource
  def singular_name, do: "Reference"

  @impl Backpex.LiveResource
  def plural_name, do: "References"

  @impl Backpex.LiveResource
  def fields do
    [
      publication: %{
        module: Backpex.Fields.Text,
        label: "Publication",
        searchable: true
      },
      publication_date: %{
        module: Backpex.Fields.Date,
        label: "Publication Date",
        format: "%B %Y",
        searchable: false
      },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title",
        searchable: true,
        render: fn assigns ->
           ~H'
            <p class="truncate">
           <%= if @item.article_url do %>
             <a class="truncate link link-hover" href={@item.article_url}>
 {truncate(@value, 25)}</a>
 <% else %>
 <%= truncate(@value, 25) %>
 <% end %></p>
         '
        end
      },
      authors: %{
        module: Backpex.Fields.Text,
        label: "Authors",
        searchable: true
      },
      edition: %{
        module: Backpex.Fields.Text,
        label: "Edition",
        searchable: true
      },
      article_url: %{
        module: Backpex.Fields.Text,
        label: "Article URL",
        searchable: true
      },
      description: %{
        module: Backpex.Fields.Textarea,
        label: "Description",
        searchable: true
      },

    ]
  end
  def truncate(value, len) do
    value
    if String.length(value) > len do
      String.slice(value, 0, len) <> "..."
    else
      value
    end
  end
end
