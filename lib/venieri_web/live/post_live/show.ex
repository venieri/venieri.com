defmodule VenieriWeb.PostLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Posts

  @impl true
  def render(assigns) do
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

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Post")
     |> assign(:post, Posts.get!(id))}
  end
end
