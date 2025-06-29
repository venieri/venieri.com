defmodule VenieriWeb.Admin.ReferencesLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Reference,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Reference.changeset/3,
      create_changeset: &Venieri.Archives.Models.Reference.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    init_order: %{by: :publication_date, direction: :desc}

  @impl Backpex.LiveResource
  def singular_name, do: "Reference"

  @impl Backpex.LiveResource
  def plural_name, do: "References"

  @impl Backpex.LiveResource
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
          ~H'<p class="truncate">
  <%= if @item.article_url do %>
    <a class="truncate link link-hover" href={@item.article_url}>
      {truncate(@value, 25)}
    </a>
  <% else %>
    {truncate(@value, 25)}
  <% end %>
</p>'
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
      uploaded_file: %{
        module: Backpex.Fields.Upload,
        label: "Upload file",
        upload_key: :uploaded_file,
        max_entries: 3,
        accept: ~w(.pdf),
        searchable: true,
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
  <a href={"/references/#{@item.uploaded_file}"}>
    {@item.uploaded_file}
  </a>
</p>'
        end
      },
      description: %{
        module: Backpex.Fields.Textarea,
        label: "Description",
        searchable: true
      }
    ]
  end

  def truncate(value, len) do
    if String.length(value) > len do
      String.slice(value, 0, len) <> "..."
    else
      value
    end
  end

  defp list_existing_files(%{uploaded_file: uploaded_file} = _item) when is_list(uploaded_file),
    do: uploaded_file

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

    cond do
      length(files) > 0 -> Map.put(params, "uploaded_file", files |> hd)
      true -> Map.put(params, "uploaded_file", nil)
    end
  end

  # sobelow_skip ["Traversal"]
  defp consume_upload(_socket, _item, %{path: path} = _meta, entry) do
    file_name = file_name(entry)
    dest = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file_name])

    File.cp!(path, dest)

    {:ok, file_url(file_name)}
  end

  # sobelow_skip ["Traversal"]
  defp remove_uploads(_socket, _item, removed_entries) do
    # for file <- removed_entries do
    #   path = Path.join([:code.priv_dir(:demo), "static", upload_dir(), file])
    #   File.rm!(path)
    # end
  end

  defp file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(VenieriWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    # [ext | _tail] = MIME.extensions(entry.client_type)
    # "#{entry.uuid}.#{ext}"
    entry.client_name
  end

  defp upload_dir, do: "references"
end
