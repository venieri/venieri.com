defmodule VenieriWeb.PostLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Posts
  alias Venieri.Archives.Models.Post


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

  def description(%Post{} = post) do
    post.description
    |> EEx.eval_string(post: post |> Venieri.Repo.preload(:media))
    |> raw()
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Post")
     |> assign(:post, Posts.get_by(slug: slug) |> Venieri.Repo.preload(:media))}
  end


  def media_grid(media_list) do
    EEx.eval_string(
      ~S"""
    <ul role="list" class="grid grid-cols-1 gap-x-4 gap-y-8 sm:grid-cols-2 sm:gap-x-6 lg:grid-cols-3 xl:gap-x-8">
    <%= for media <- media_list do %>
        <li class="relative">
            <div class="group overflow-hidden rounded-lg focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 focus-within:ring-offset-gray-100">
                   <a href=<%= "/media/#{media.slug}" %> >
                    <img
                        class="pointer-events-none  object-cover group-hover:opacity-75"
                        src= <%= "#{Venieri.Archives.Media.url(media)}" %>
                        alt= <%= "Lydie Venieri - #{media.caption}" %>
                        />
                        </a>

            </div>
            <p class="mt-2 block truncate text-sm font-medium text-gray-900">
                <a href=<%= "/media/#{media.slug}" %> >
                    <%=  media.caption %>
                </a>
            </p>
        </li>
    <% end %>
    </ul>
    """, media_list: media_list)
  end
end
