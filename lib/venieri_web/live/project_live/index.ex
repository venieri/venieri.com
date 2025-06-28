defmodule VenieriWeb.ProjectsLive.Index do
  use VenieriWeb, :live_view
  require Logger
  alias Venieri.Repo
  alias Venieri.Archives.Projects
  alias Venieri.Archives.Events
  alias Venieri.Archives.References

  import VenieriWeb.Components.Navbar



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
    projects = Projects.list()

    {:ok,
     socket
     |> assign(projects: projects)}

    # {:ok,
    #  socket
    #  |> assign(page: 0), temporary_assigns: [events: []]}
  end

  @impl true
  def handle_event(_, _, socket) do
    {:noreply, socket}
  end
end
