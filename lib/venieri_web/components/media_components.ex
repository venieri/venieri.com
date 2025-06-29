defmodule VenieriWeb.MediaComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component
  use Gettext, backend: VenieriWeb.Gettext

  alias Phoenix.LiveView.JS

  attr :media, :map, required: true
  attr :figure_class, :string, default: ""

  attr :figcaption_class, :string,
    default: "text-right text-sm text-neutral-600 dark:text-neutral-400"

  attr :img_class, :string, default: "object-cover w-full  md:h-auto"
  attr :size, :integer, default: 640
  attr :alt, :string, default: nil
  attr :caption, :boolean, default: true

  def media_in_figure(assigns) do
    ~H"""
    <figure class={@figure_class}>
      <.media_as_picture media={@media} size={@size} class={@img_class} />
      <figcaption :if={@caption} class={@figcaption_class}>
        {@media.caption}
      </figcaption>
    </figure>
    """
  end

  @doc """
  Renders a media entity using a picture element with srcset  generated from the media entity for
  different sizes and both avif and webp extensions.

  ## Examples
      <.local_media media={@media}  size={7680}/>
      <.local_media media={@media}  class={"object-cover w-full  md:h-auto"} size={7680}/>
  """

  attr :media, :map
  attr :slug, :string
  attr :figure_class, :string, default: "object-cover w-full  md:h-auto"
  attr :figcaption_class, :string, default: "object-cover w-full  md:h-auto"
  attr :class, :string, default: "object-cover w-full  md:h-auto"
  attr :size, :integer, default: 640
  attr :alt, :string, default: nil
  attr :force_size, :boolean, default: false

  def media_as_picture(assigns) do
    assigns =
      cond do
        Map.has_key?(assigns, :media) ->
          assigns

        Map.has_key?(assigns, :slug) ->
          assign(assigns, media: Venieri.Archives.Media.get_by(slug: assigns.slug))

        true ->
          assigns
      end

    ~H"""
    <%= case @media.type do %>
      <% "image" -> %>
        <picture class={@class}>
          <%= if @force_size do %>
            <source srcset={media_src(@media, @size, "avif")} type="image/avif" />
            <source srcset={media_src(@media, @size, "webp")} type="image/webp" />
          <% else %>
            <source srcset={media_srcset(@media, @size, "avif")} type="image/avif" />
            <source srcset={media_srcset(@media, @size, "webp")} type="image/webp" />
          <% end %>
          <img
            id={"img-#{@media.id}"}
            class={@class}
            }
            alt={@alt || @media.caption}
            src={Venieri.Archives.Media.url(@media, width: @size, type: "avif")}
            sizes={"(max-width: #{@size}px) #{@size}px"}
          />
        </picture>
    <% end %>
    """
  end

  def media_as_picture2(assigns) do
    ~H"""
    <%= cond do %>
      <% is_nil(@media.video_uri) == false -> %>
        <%!-- {Phoenix.HTML.raw @media.video_uri} --%>
        <iframe
          class={[@class, "aspect-video"]}
          src={@media.video_uri}
          frameborder="0"
          allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media"
          title="The Byronic Codex - A documentary"
        >
        </iframe>
      <% @media.type == "MP4" -> %>
        <video class={["aspect-video", @class]} controls>
          <source src={"/uploads/media/#{@media.original_file}"} type="video/mp4" />
        </video>
      <% true -> %>
        <picture class={@class}>
          <source srcset={media_srcset(@media, @size, "avif")} type="image/avif" />
          <source srcset={media_srcset(@media, @size, "webp")} type="image/webp" />
          <img
            id={"img-#{@media.id}"}
            class={@class}
            }
            alt={@alt || @media.caption}
            src={Venieri.Entity.url(@media, @size, "avif")}
            sizes="(max-width: 7680px) {@size}px, 50vw"
          />
        </picture>
    <% end %>
    """
  end

  def media_srcset(media, size, extension \\ "avif") do
    [150, 480, 640, 1024, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
    |> Enum.map(fn size ->
      "#{Venieri.Archives.Media.url(media, width: size, type: extension)} #{size}w"
    end)
    |> Enum.join(", ")
  end

  def media_src(media, size, extension \\ "avif") do
    Venieri.Archives.Media.url(media, width: size, type: extension)
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr(:type, :string, default: nil)
  attr(:class, :string, default: nil)
  attr(:rest, :global, include: ~w(disabled form name value))

  slot(:inner_block, required: true)

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr(:class, :string, default: nil)

  slot(:inner_block, required: true)
  slot(:subtitle)
  slot(:actions)

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr(:navigate, :any, required: true)
  slot(:inner_block, required: true)

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr(:name, :string, required: true)
  attr(:class, :string, default: nil)

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
