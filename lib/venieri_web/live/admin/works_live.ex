defmodule VenieriWeb.Admin.WorksLive do
  use Backpex.LiveResource,
    adapter_config: [
      schema: Venieri.Archives.Models.Work,
      repo: Venieri.Repo,
      update_changeset: &Venieri.Archives.Models.Work.changeset/3,
      create_changeset: &Venieri.Archives.Models.Work.changeset/3
    ],
    layout: {VenieriWeb.Layouts, :admin},
    pubsub: [
      server: Venieri.PubSub,
      topic: "works"
    ]

  # def render_resource_slot(assigns, :show, :before_main) do
  #   ~H"""
  #   <%= if hd(@item.media).video_uri != nil do %>
  #     <iframe class="aspect-video" src={hd(@item.media).video_uri}></iframe>
  #   <% else %>
  #     <div class="carousel">
  #       <div :for={img <- @item.media} class="carousel-item">
  #         <%!-- <video src={img.video_uri} class="h-96 w-auto" controls /> --%>
  #         <img class="h-96 w-auto" src={file_url(img.original_file)} alt={img.caption} />
  #       </div>
  #     </div>
  #   <% end %>
  #   """
  # end
  #
  import Ecto.Query, warn: false
  require Logger

  import VenieriWeb.MediaComponents

  @impl Backpex.LiveResource
  def singular_name, do: "Work"

  @impl Backpex.LiveResource
  def plural_name, do: "Works"

  @impl Backpex.LiveResource
  def filters() do
    [
      category_id: %{
        module: VenieriWeb.Admin.Filters.ProjectFilter,
        label: "Project"
      }
    ]
  end


  #     #     user_id: %{
  #     #       module: DemoWeb.Filters.PostUserMultiSelect,
  #     #       label: "Users"
  #     #     },
  #     #     likes: %{
  #     #       module: DemoWeb.Filters.PostLikeRange,
  #     #       label: "Likes",
  #     #       presets: [
  #     #         %{
  #     #           label: "Over 100",
  #     #           values: fn -> %{"start" => 100, "end" => nil} end
  #     #         },
  #     #         %{
  #     #           label: "1-99",
  #     #           values: fn -> %{"start" => 1, "end" => 99} end
  #     #         }
  #     #       ]
  #     #     },
  #     #     inserted_at: %{
  #     #       module: DemoWeb.Filters.DateTimeRange,
  #     #       label: "Created at",
  #     #       presets: [
  #     #         %{
  #     #           label: "Last 7 Days",
  #     #           values: fn ->
  #     #             %{
  #     #               "start" => Date.add(Date.utc_today(), -7),
  #     #               "end" => Date.utc_today()
  #     #             }
  #     #           end
  #     #         },
  #     #         %{
  #     #           label: "Last 14 Days",
  #     #           values: fn ->
  #     #             %{
  #     #               "start" => Date.add(Date.utc_today(), -14),
  #     #               "end" => Date.utc_today()
  #     #             }
  #     #           end
  #     #         },
  #     #         %{
  #     #           label: "Last 30 Days",
  #     #           values: fn ->
  #     #             %{
  #     #               "start" => Date.add(Date.utc_today(), -30),
  #     #               "end" => Date.utc_today()
  #     #             }
  #     #           end
  #     #         }
  #     #       ]
  #     #     },
  #     published: %{
  #       module: VenieriWeb.Admin.Filters.ShowFilter,
  #       label: "Showing?",
  #       default: ["showing", "not_showing"],
  #       presets: [
  #         %{
  #           label: "Both",
  #           values: fn -> [:showing, :not_showing] end
  #         },
  #         %{
  #           label: "Only showing",
  #           values: fn -> [:showing] end
  #         },
  #         %{
  #           label: "Only not showing",
  #           values: fn -> [:not_showing] end
  #         }
  #       ]
  #     }
  #   ]
  # end

  @impl Backpex.LiveResource
  def fields do
    [
      id: %{
        module: Backpex.Fields.Text,
        label: "ID",
        readonly: true
      },
      # project: %{
      #   module: Backpex.Fields.BelongsTo,
      #   label: "Project",
      #   live_resource: VenieriWeb.Admin.ProjectsLive,
      #   display_field: :title,
      #   searchable: true
      # },
      title: %{
        module: Backpex.Fields.Text,
        label: "Title",
        searchable: true
      },
      sd_category: %{
        module: Backpex.Fields.Text,
        label: "SEO Category",
        searchable: true
      },
      project: %{
        module: Backpex.Fields.BelongsTo,
        label: "Project",
        live_resource: VenieriWeb.Admin.ProjectsLive,
        display_field: :title,
        searchable: true
      },
      # poster: %{
      #   module: Backpex.Fields.BelongsTo,
      #   label: "Poster",
      #   live_resource: VenieriWeb.Admin.MediaLive,
      #   display_field: :caption
      # },
      media: %{
        module: Backpex.Fields.Many,
        label: "Media",
        orderable: true,
        searchable: true,
        display_field: :icon,
        # display_field_form: :icon,
        display_field_form: fn media ->
          # Logger.error("display_field_form #{inspect(media)}")
          # %{caption: media.caption, icon: media.icon}
          media
        end,
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
      show: %{
        module: Backpex.Fields.Boolean,
        label: "Show",
        align: :center
      },
      slug: %{
        module: Backpex.Fields.Text,
        label: "Slug"
      },
      year: %{
        module: Backpex.Fields.Number,
        label: "Year"
      },
      medium: %{
        module: Backpex.Fields.Text,
        label: "Media"
      },
      size: %{
        module: Backpex.Fields.Text,
        label: "Size"
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
      tags: %{
        module: Backpex.Fields.HasMany,
        label: "Tags",
        orderable: false,
        display_field: :label,
        live_resource: VenieriWeb.Admin.TagsLive,
        except: [:index]
      }
      # uploads: %{
      #   module: Backpex.Fields.Upload,
      #   label: "Upload Media",
      #   upload_key: :uploads,
      #   accept: ~w(.jpg .jpeg .png),
      #   max_entries: 1000,
      #   max_file_size: 1_000_000_000,
      #   put_upload_change: &put_upload_change/6,
      #   consume_upload: &consume_upload/4,
      #   remove_uploads: &remove_uploads/3,
      #   list_existing_files: &list_existing_files/1,
      #   render: fn
      #     %{value: value} = assigns when is_list(value) ->
      #       ~H'''
      #       <div>
      #         <img :for={img <- @value} class="h-10 w-auto" src={file_url(img)} />
      #       </div>
      #       '''

      #     assigns ->
      #       ~H'<p>{Backpex.HTML.pretty_value(@value)}</p>'
      #   end,
      #   except: [:index, :resource_action],
      #   align: :center
      # }
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
    |> Venieri.Archives.Models.Work.changeset_update_media([media])
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

  defp upload_dir, do: Application.fetch_env!(:venieri, :uploads)[:upload_path]
end
