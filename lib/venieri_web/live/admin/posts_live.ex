defmodule VenieriWeb.Admin.PostsLive do
  alias Backpex.Ecto.Amount.Type

  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Post,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Post.changeset/3,
      create_changeset: &Venieri.Archives.Models.Post.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      server: Venieri.PubSub,
      topic: "projects"
    ],
    init_order: %{by: :post_date, direction: :desc}

  import Ecto.Query, warn: false

  import VenieriWeb.MediaComponents

  require Backpex
  alias Backpex.Router

  @impl Backpex.LiveResource
  def singular_name, do: "Post"

  @impl Backpex.LiveResource
  def plural_name, do: "Posts"

  @impl Backpex.LiveResource
  def panels do
    [
      event: "Event Info"
    ]
  end

  @impl Backpex.LiveResource
  def fields do
    [
      to_show: %{
        module: Backpex.Fields.Boolean,
        label: "Visible",
        align: :center,
        index_editable: true
      },
      post_date: %{
        module: Backpex.Fields.Date,
        label: "Date"
      },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title"
      },
      slug: %{
        module: Backpex.Fields.Text,
        label: "Slug",
        except: [:index],
      },
      type: %{
        module: Backpex.Fields.Select,
        label: "Type",
        options: [Article: "article", Event: "event", Other: "other"]
      },
      logline: %{
        module: Backpex.Fields.Textarea,
        label: "Leader",
        except: [:index],
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
      venue: %{
        module: Backpex.Fields.Text,
        label: "Venue",
        panel: :event
      },
      location: %{
        module: Backpex.Fields.Text,
        label: "Location",
        panel: :event
      },
      location_url: %{
        module: Backpex.Fields.Text,
        label: "Location Url",
        panel: :event,
        except: [:index],
      },
      start_date: %{
        module: Backpex.Fields.DateTime,
        label: "Start",
        panel: :event,
        except: [:index],
      },
      end_date: %{
        module: Backpex.Fields.DateTime,
        label: "End",
        panel: :event,
        except: [:index],
      },
      event_url: %{
        module: Backpex.Fields.Text,
        label: "event_url",
        panel: :event,
        except: [:index],
      },
      press_release: %{
        module: Backpex.Fields.Upload,
        except: [:index],
        label: "Press Release",
        panel: :event,
        upload_key: :press_release,
        accept: ~w(.pdf),
        max_file_size: 10_000_000,
        put_upload_change: &put_upload_change/6,
        consume_upload: &consume_upload/4,
        remove_uploads: &remove_uploads/3,
        list_existing_files: &list_existing_files/1,
        render: fn
          %{value: value} = assigns when value == "" or is_nil(value) ->
            dbg(value)
            ~H"<p>{Backpex.HTML.pretty_value(@value)}</p>"

          assigns ->
            dbg(assigns.item)
            ~H'<a href={file_url(@item.slug <> ".pdf")}>{Backpex.HTML.pretty_value(@value)}</a>'
        end
      },
      media: %{
        module: Backpex.Fields.Many,
        except: [:index],
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
      tags: %{
        except: [:index],
        module: Backpex.Fields.HasMany,
        label: "Tags",
        orderable: false,
        display_field: :label,
        live_resource: VenieriWeb.Admin.TagsLive,
        except: [:index]
      }
    ]
  end

  defp list_existing_files(%{press_release: press_release} = _item)
       when press_release != "" and not is_nil(press_release),
       do: [press_release]

  defp list_existing_files(_item), do: []

  def put_upload_change(_socket, params, item, uploaded_entries, removed_entries, action) do
    existing_files = list_existing_files(item) -- removed_entries

    new_entries =
      case action do
        :validate ->
          elem(uploaded_entries, 1)

        :insert ->
          elem(uploaded_entries, 0)
      end

    files = existing_files ++ Enum.map(new_entries, fn entry -> file_name(entry) end)

    case files do
      [file] ->
        Map.put(params, "press_release", file)

      [_file | _other_files] ->
        Map.put(params, "press_release", "too_many_files")

      [] ->
        Map.put(params, "press_release", "")
    end
  end

  defp consume_upload(_socket, item, %{path: path} = _meta, entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    file_name = "#{item.slug}.#{ext}"
    dest = Path.join([:code.priv_dir(:venieri), "static", "press_releases", file_name])

    File.cp!(path, dest)

    {:ok, file_url(file_name)}
  end

  defp remove_uploads(_socket, _item, removed_entries) do
    for file <- removed_entries do
      path = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file])
      File.rm!(path)
    end
  end

  defp file_url(file_name) do
    dbg(file_name)
    static_path = Path.join(["press_releases", file_name])

    Phoenix.VerifiedRoutes.static_url(VenieriWeb.Endpoint, "/" <> static_path)
    |> dbg()
  end

  defp file_name(entry) do
    entry.client_name
  end

  defp upload_dir, do: Path.join(["uploads", "press_releases"])
end
