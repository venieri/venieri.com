defmodule VenieriWeb.PostLive.Index do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Posts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Posts
        <:actions>
          <.button variant="primary" navigate={~p"/posts/new"}>
            <.icon name="hero-plus" /> New Post
          </.button>
        </:actions>
      </.header>

      <.table
        id="posts"
        rows={@streams.posts}
        row_click={fn {_id, post} -> JS.navigate(~p"/posts/#{post}") end}
      >
        <:col :let={{_id, post}} label="Title">{post.title}</:col>
        <:col :let={{_id, post}} label="Slug">{post.slug}</:col>
        <:col :let={{_id, post}} label="Logline">{post.logline}</:col>
        <:col :let={{_id, post}} label="Description">{post.description}</:col>
        <:col :let={{_id, post}} label="Post date">{post.post_date}</:col>
        <:col :let={{_id, post}} label="To show">{post.to_show}</:col>
        <:col :let={{_id, post}} label="Orientation">{post.orientation}</:col>
        <:action :let={{_id, post}}>
          <div class="sr-only">
            <.link navigate={~p"/posts/#{post}"}>Show</.link>
          </div>
          <.link navigate={~p"/posts/#{post}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, post}}>
          <.link
            phx-click={JS.push("delete", value: %{id: post.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:bg_color, "bg-white")
     |> assign(:page_title, "Listing Posts")
     |> stream(:posts, Posts.list())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get!(id)
    {:ok, _} = Posts.delete(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
