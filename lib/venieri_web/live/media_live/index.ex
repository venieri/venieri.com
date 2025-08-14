defmodule VenieriWeb.MediaLive.Index do
  use VenieriWeb, :live_view

  import Ecto.Query
  alias Venieri.Archives.Models.Media

  alias Venieri.Repo

  import VenieriWeb.Components.Navbar


  @impl true
  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(:bg_color, "bg-white")
    |> assign(:page_title, "Listing Media")
    |> assign(page: 1, per_page: 20)
    |> paginate(1)}
  end

  defp paginate(socket, new_page) when new_page >= 1 do
    %{per_page: per_page, page: cur_page} = socket.assigns
    media = get_media(offset: (new_page - 1) * per_page, limit: per_page)

    {media, at, limit} =
      if new_page >= cur_page do
        {media, -1, per_page * 3 * -1}
      else
        {Enum.reverse(media), 0, per_page * 3}
      end

    case media do
      [] ->
        assign(socket, end_of_timeline?: at == -1)

      [_ | _] = media ->
        socket
        |> assign(end_of_timeline?: false)
        |> assign(:page, new_page)
        |> stream(:media, media, at: at, limit: limit)
    end
  end

  defp get_media(offset: offset, limit: limit) do
    Media
    |> order_by([m], desc: m.inserted_at)
    |> offset(^offset)
    |> limit(^limit)
    |> Repo.all()
  end

  def handle_event("next-page", _, socket) do
    {:noreply, paginate(socket, socket.assigns.page + 1)}
  end

  def handle_event("prev-page", %{"_overran" => true}, socket) do
    {:noreply, paginate(socket, 1)}
  end

  def handle_event("prev-page", _, socket) do
    if socket.assigns.page > 1 do
      {:noreply, paginate(socket, socket.assigns.page - 1)}
    else
      {:noreply, socket}
    end
  end

end
