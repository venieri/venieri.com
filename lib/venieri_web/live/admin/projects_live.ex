defmodule VenieriWeb.Admin.ProjectsLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Project,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Project.changeset/3,
      create_changeset: &Venieri.Archives.Models.Project.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      server: Venieri.PubSub,
      topic: "projects"
    ]

  import Ecto.Query, warn: false

  import VenieriWeb.MediaComponents

  require Backpex
  alias Backpex.Router

  @impl Backpex.LiveResource
  def singular_name, do: "Project"

  @impl Backpex.LiveResource
  def plural_name, do: "Projects"

  @impl Backpex.LiveResource
  def fields do
    [
    id: %{
        module: Backpex.Fields.Text,
        label: "ID",
        readonly: true
      },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title"
      },
      slug: %{
        module: Backpex.Fields.Text,
        label: "Slug"
      },
      show: %{
        module: Backpex.Fields.Boolean,
        label: "Show",
        align: :center
      },
      tags: %{
        module: Backpex.Fields.HasMany,
        label: "Tags",
        orderable: false,
        display_field: :label,
        live_resource: VenieriWeb.Admin.TagsLive,
        except: [:index]
      },
      media: %{
        module: Backpex.Fields.Many,
        label: "Media",
        orderable: true,
        searchable: true,
        display_field: :caption,
        display_field_form: fn media -> media end,
        live_resource: VenieriWeb.Admin.MediaLive,
        except: [:index],
        render: fn assigns ->
          ~H'''
          <div>
            <ul>
              <%= for media <- @value do %>
                <li><.media_as_picture media={media} size={480} class="inline-block h-16" /></li>
              <% end %>
            </ul>
          </div>
          '''
        end,
        options_query: &Venieri.Archives.Media.select_media/2
      },
      description: %{
        module: Backpex.Fields.Textarea,
        label: "Description",
        rows: 10,
        except: [:index],
        render: fn assigns ->
          ~H'''
          <div>
            {raw(@value)}
          </div>
          '''
        end
      },
      statement: %{
        module: Backpex.Fields.Textarea,
        label: "Statement",
        rows: 10,
        except: [:index],
        render: fn assigns ->
          ~H'''
          <div>
            {raw(@value)}
          </div>
          '''
        end
      }
    ]
  end
end
