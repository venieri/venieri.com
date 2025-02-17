defmodule VenieriWeb.AdminProjectLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Project,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Project.changeset/3,
      create_changeset: &Venieri.Archives.Models.Project.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      name: Venieri.PubSub,
      topic: "projects",
      event_prefix: "project_"
    ],
    fluid?: true

  @impl Backpex.LiveResource
  def singular_name, do: "Project"

  @impl Backpex.LiveResource
  def plural_name, do: "Projects"

  @impl Backpex.LiveResource
  def fields do
    [
      id: %{
        module: Backpex.Fields.Text,
        label: "Id",
        readonly: true
      },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title",
        searchable: true
      },
      show: %{
        module: Backpex.Fields.Boolean,
        label: "Show",
        align: :center
      },
      slug: %{
        module: Backpex.Fields.Text,
        label: "Slug"
      },
      description: %{
        module: Backpex.Fields.Textarea,
        label: "Description",
        rows: 10,
        except: [:index],
        render: fn assigns ->
          ~H'''
            <div>
            {raw @value }
            </div>
            '''
        end
      },
      tags: %{
        module: Backpex.Fields.HasMany,
        label: "Tags",
        orderable: false,
        display_field: :label,
        live_resource: VenieriWeb.AdminTagLive,
        except: [:index]
      },
      statement: %{
        module: Backpex.Fields.Textarea,
        label: "Statement",
        rows: 10,
        except: [:index],
        render: fn assigns ->
          ~H'''
            <div>
              {raw @value }
            </div>
            '''
        end
      }
    ]
  end
end
