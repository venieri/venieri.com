defmodule VenieriWeb.Admin.MediaLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Media,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Media.changeset/3,
      create_changeset: &Venieri.Archives.Models.Media.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      server: Venieri.PubSub,
      topic: "media"
    ],
    init_order: %{by: :year, direction: :desc}

  alias Venieri.Archives.Media

  require Logger

  import VenieriWeb.MediaComponents

  @impl Backpex.LiveResource
  def singular_name, do: "Media"

  @impl Backpex.LiveResource
  def plural_name, do: "Media"

  @impl Backpex.LiveResource
  def render_resource_slot(assigns, :show, :before_main) do
    ~H"""
    <div>
      <.media_as_picture media={@item} size={480} class="inline-block h-64" />
    </div>
    """
  end

  @impl Backpex.LiveResource
  def fields do
    [
      caption: %{
        module: Backpex.Fields.Text,
        label: "Caption",
        searchable: true
      },
      slug: %{
        module: Backpex.Fields.Text,
        label: "Slug",
        searchable: true
      },
      external_uri: %{
        module: Backpex.Fields.Text,
        label: "External URI"
      },
      uploaded_file: %{
        module: Backpex.Fields.Upload,
        label: "Upload file",
        upload_key: :uploaded_file,
        accept: ~w(.jpg .jpeg .png .tif .webp .avif .heic .heif .mp4 .mov),
        max_file_size: 3_000_000_000,
        put_upload_change: &put_upload_change/6,
        list_existing_files: &list_existing_files/1,
        consume_upload: &consume_upload/4,
        remove_uploads: &remove_uploads/3,
        render: fn
          %{value: value} = assigns when value == "" or is_nil(value) ->
            ~H"<p>{Backpex.HTML.pretty_value(@value)}</p>"

          assigns ->
            ~H'<p>
  <a href={"/uploads/#{@item.uploaded_file}"}>
    <.media_as_picture media={@item} size={480} class="inline-block h-16" />
  </a>
  <br />
  {@value}
</p>'
        end
      },
      embeded_html: %{
        module: Backpex.Fields.Textarea,
        label: "Embed",
        rows: 10,
        except: [:index]
      },
      type: %{
        module: Backpex.Fields.Text,
        label: "Type",
        readonly: true
      },
      width: %{
        module: Backpex.Fields.Text,
        label: "Width",
        readonly: true
      },
      height: %{
        module: Backpex.Fields.Text,
        label: "Height",
        readonly: true
      },
      meta_data: %{
        module: Backpex.Fields.Map,
        label: "Meta data",
        rows: 10,
        except: [:index],
        readonly: true
      }
    ]
  end

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
        params
        |> Map.put("uploaded_file", file)

      # |> Map.put("caption", "too_many_files")
      [_file | _other_files] ->
        Map.put(params, "uploaded_file", "too_many_files")

      [] ->
        Map.put(params, "uploaded_file", "")
    end
  end

  defp consume_upload(_socket, item, %{path: path} = _meta, _entry) do
    {:ok, Media.process_upload(item, path) |> Media.url(width: 150)}
  end

  defp remove_uploads(_socket, _item, _removed_entries) do
    # for file <- removed_entries do
    #   path = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file])
    #   File.rm!(path)
    # end
  end

  defp list_existing_files(%{original_file: original_file} = _item)
       when original_file != "" and not is_nil(original_file),
       do: [original_file]

  defp list_existing_files(_item), do: []

  defp file_name(entry) do
    entry.client_name
    #   entry |> dbg()
    #   [ext | _] = MIME.extensions(entry.client_type)
    #   slug = Slug.slugify(Path.rootname(entry.client_name))
    #   count = Venieri.Archives.Counters.inc(slug) |> dbg()

    #   if count > 1 do
    #     # uuid = Slug.slugify(id |> Integer.to_string(36))
    #     "#{slug}-#{count}.#{ext}"
    #   else
    #     "#{slug}.#{ext}"
    #   end
  end
end

# 13th Month Sculpture in the Ano Mera garden
