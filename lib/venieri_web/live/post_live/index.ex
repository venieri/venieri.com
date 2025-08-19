defmodule VenieriWeb.PostLive.Index do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Posts
  alias Venieri.Archives.Models.Post

  import Ecto.Query, only: [from: 2]

  alias Venieri.Repo

  import VenieriWeb.Components.Navbar


  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:bg_color, "bg-white")
     |> assign(:page_title, "Listing Posts")
     |> assign(page: 1, per_page: 20)
     |> paginate_posts(1)
     |> assign(view: :events)}
  end

  defp paginate_posts(socket, new_page) when new_page >= 1 do
    %{per_page: per_page, page: cur_page} = socket.assigns |> dbg()
    posts = get_posts(offset: (new_page - 1) * per_page, limit: per_page)

    {posts, at, limit} =
      if new_page >= cur_page do
        {posts, -1, per_page * 3 * -1}
      else
        {Enum.reverse(posts), 0, per_page * 3}
      end

    case posts do
      [] ->
        assign(socket, end_of_timeline?: at == -1)

      [_ | _] = posts ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:page, new_page)
        |> stream(:posts, posts, at: at, limit: limit)
    end
  end

  def get_posts(options) do
    offset = Keyword.get(options, :offset, 0)
    limit = Keyword.get(options, :limit, 20)

    query =
    (from p in Post,
    where: p.to_show == true,
    order_by: [desc: p.post_date],
    preload: [:media],
    offset: ^offset,
    limit: ^limit)
    |> Repo.all()
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get!(id)
    {:ok, _} = Posts.delete(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  def handle_event("next-page", _, socket) do
    {:noreply, paginate_posts(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate_posts(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate_posts(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end
end
