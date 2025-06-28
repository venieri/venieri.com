defmodule VenieriWeb.Admin.TagsLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Tag,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Tag.changeset/3,
      create_changeset: &Venieri.Archives.Models.Tag.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    init_order: %{by: :label, direction: :asc}

  @impl Backpex.LiveResource
  def singular_name, do: "Tag"

  @impl Backpex.LiveResource
  def plural_name, do: "Tags"

  @impl Backpex.LiveResource
  def fields do
    [
      label: %{
        module: Backpex.Fields.Text,
        label: "Label"
      },
      projects: %{
        module: Backpex.Fields.HasMany,
        label: "Projects",
        orderable: false,
        display_field: :title,
        live_resource: VenieriWeb.Admin.ProjectsLive,
        except: [:index]
      }
    ]
  end
end
