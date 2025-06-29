defmodule VenieriWeb.Admin.SnippetsLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Snippet,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Snippet.changeset/3,
      create_changeset: &Venieri.Archives.Models.Snippet.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    init_order: %{by: :label, direction: :asc}

  @impl Backpex.LiveResource
  def singular_name, do: "Snippet"

  @impl Backpex.LiveResource
  def plural_name, do: "Snippets"

  @impl Backpex.LiveResource
  def fields do
    [
      label: %{
        module: Backpex.Fields.Text,
        label: "Label"
      },
      content: %{
        module: Backpex.Fields.Textarea,
        label: "Content",
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
