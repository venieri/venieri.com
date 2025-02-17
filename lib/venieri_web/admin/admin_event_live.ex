defmodule VenieriWeb.AdminEventLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Event,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Event.changeset/3,
      create_changeset: &Venieri.Archives.Models.Event.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      name: Venieri.PubSub,
      topic: "events",
      event_prefix: "event_"
    ],
    fluid?: true

  alias Venieri.Archives.Media

  @impl Backpex.LiveResource
  def singular_name, do: "Event"

  @impl Backpex.LiveResource
  def plural_name, do: "Events"

  def render_resource_slot(assigns, :show, :before_main) do
    ~H"""
    <div class="carousel">
      <div class="carousel-item" :for={img <- @item.media}  >
        <img
           class="h-96 w-auto"
          src={file_url(img.original_file)}
          alt={img.caption} />
      </div>
    </div>

    """
  end

  @impl Backpex.LiveResource
  def fields do
    [
      show: %{
        module: VenieriWeb.Admin.Fields.Boolean,
        label: "Show",
        align: :center,
        index_editable: true
      },
      media: %{
        module: Backpex.Fields.HasMany,
        label: "Media",
        orderable: false,
        display_field: :original_file,
        live_resource: VenieriWeb.AdminMediaLive,
        # except: [:index],
        render: fn
          %{value: value} = assigns when is_list(value) and length(value) > 0 ->
            ~H'''
            <div>
              <img  class="h-10 w-auto" src={file_url((@value |> hd).original_file)} />
            </div>
            '''

          assigns ->
            ~H'<p><%= Backpex.HTML.pretty_value(@value) %></p>'
        end,
      },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title",
        searchable: true
      },
      venue: %{
        module: Backpex.Fields.Text,
        label: "Venue"
      },
      start_date: %{
        module: Backpex.Fields.DateTime,
        label: "Start Date"
      },
        end_date: %{
          module: Backpex.Fields.DateTime,
          label: "End Date"
        },
      orientation: %{
        module: Backpex.Fields.Select,
        label: "Orientation",
        options: [
          {:auto, "Auto"},
          {:horizontal, "Horizontal"},
          {:left, "Left"},
          {:right, "Right"}
        ]
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
        except: [:index],render: fn assigns ->
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
      }
    ]
  end

  defp list_existing_files(%{uploads: uploads} = _item) when is_list(uploads), do: uploads
  defp list_existing_files(_item), do: []

  defp put_upload_change(_socket, params, item, uploaded_entries, removed_entries, action) do
    existing_files = list_existing_files(item) -- removed_entries

    new_entries =
      case action do
        :validate ->
          elem(uploaded_entries, 1)

        :insert ->
          elem(uploaded_entries, 0)
      end

    files = existing_files ++ Enum.map(new_entries, fn entry -> file_name(entry) end)

    Map.put(params, "uploads", files)
  end

  defp consume_upload(_socket, work, %{path: path} = meta, entry) do
    media = Media.process_upload(work, entry, meta)

    file_name = file_name(entry)
    dest = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file_name])

    File.cp!(path, dest)
    work
    |> Venieri.Repo.preload(:media)
    |> Venieri.Archives.Models.Event.changeset_update_media([media])
    |> Venieri.Repo.update!()
    {:ok, file_url(file_name)}
  end

  defp remove_uploads(_socket, _item, removed_entries) do
    for file <- removed_entries do
      path = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file])
      File.rm!(path)
    end
  end

  defp file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(VenieriWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    entry.uuid <> "." <> ext
  end

  defp upload_dir, do: Path.join(["uploads",  "media"])

end
