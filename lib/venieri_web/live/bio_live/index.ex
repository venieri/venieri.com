defmodule VenieriWeb.BioLive.Index do
  use VenieriWeb, :live_view
  require Logger
  alias Venieri.Repo
  alias Venieri.Archives.Projects
  alias Venieri.Archives.Posts
  alias Venieri.Archives.References

  import VenieriWeb.Components.Navbar
  import VenieriWeb.MediaComponents

  @impl true
  def mount(_params, _session, socket) do
    # socket = assign(socket, page: 1)

    # # on initial load it'll return false,
    # # then true on the next.
    # if connected?(socket) do
    #   get_events(socket)
    # else
    #   socket
    # end
    Date.utc_today()

    solo_shows =
      Posts.by_tag("Solo Show")
      |> Enum.group_by(& &1.post_date.year, & &1)
      |> Enum.sort_by(&elem(&1, 0), :desc)

    group_shows =
      Posts.by_tag("Group Show")
      |> Enum.group_by(& &1.post_date.year, & &1)
      |> Enum.sort_by(&elem(&1, 0), :desc)

    references =
      References.list()
      |> Enum.sort_by(& &1.publication_date, :desc)

    {:ok,
     socket
     |> assign(:bg_color, "bg-white")
     |> assign(solo_shows: solo_shows)
     |> assign(group_shows: group_shows)
     |> assign(references: references)
     |> assign(view: :bio)}

    # {:ok,
    #  socket
    #  |> assign(page: 0), temporary_assigns: [events: []]}
  end

  @impl true
  def handle_event(_, _, socket) do
    {:noreply, socket}
  end

end
