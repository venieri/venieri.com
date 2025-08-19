defmodule VenieriWeb.WorkLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Works
  alias Venieri.Archives.Models.Work, as: ArtWork


  import VenieriWeb.Components.Navbar

  @impl true
  def render2(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Post {@post.id}
        <:subtitle>This is a post record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/posts"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/posts/#{@post}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit post
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@post.title}</:item>
        <:item title="Slug">{@post.slug}</:item>
        <:item title="Logline">{@post.logline}</:item>
        <:item title="Description">{@post.description}</:item>
        <:item title="Post date">{@post.post_date}</:item>
        <:item title="To show">{@post.to_show}</:item>
        <:item title="Orientation">{@post.orientation}</:item>
      </.list>
    </Layouts.app>
    """
  end

  def description(%ArtWork{description: nil} = art_work) do
    ""
  end

  def description(%ArtWork{description: description} = art_work) do
    art_work.description
    |> EEx.eval_string(art_work: art_work |> Venieri.Repo.preload(:media))
    |> raw()
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    art_work = Works.get_by(slug: slug)
    |> Venieri.Repo.preload(:media)
    {:ok,
     socket
     |> assign(:page_title, "#{art_work.title}")
     |> assign(:work, art_work)}
  end




  attr :media_list, :list, required: true
  def media_collage(assigns) do
      ~H"""

      <ul class="flex flex-wrap gap-1">
<li
  class={[
    "h-[300px]", "grow-1", "last:grow-10"
  ]}

  :for={media <- @media_list } >


  <picture class="w-full h-full">
      <source srcset = { "#{VenieriWeb.MediaComponents.media_srcset(media, 1024)}" }
              type="image/avif" />
      <source srcset = { "#{VenieriWeb.MediaComponents.media_srcset(media, 1024)}" }
              type="image/webp" />
      <img
        class={[
            "object-cover",
            "w-full", "max-h-full"
          ]}
        alt=  { "Lydia Venieri - {media.caption}" }
        src= { "#{Venieri.Archives.Media.url(media, width: 1024, type: "avif")}" }
        sizes="(max-width: 2048px) 2048px, 50vw"
      />
    </picture>
</li>

</ul>
"""
  end
end
