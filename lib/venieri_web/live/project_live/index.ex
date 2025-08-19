defmodule VenieriWeb.ProjectLive.Index do
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
     |> assign(view: :projects)
     |> assign(projects: projects)
  }

    # {:ok,
    #  socket
    #  |> assign(page: 0), temporary_assigns: [events: []]}
  end

  @impl true
  def handle_event(_, _, socket) do
    {:noreply, socket}
  end


  def r(assigns) do
~H"""
    <div class="mb-5 mt-10">
    <h1 class="text-2xl/7 font-bold text-gray-700 sm:truncate sm:text-3xl sm:tracking-tight">PROJECTS</h1>
    </div>

     <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          <%= for batch <- Enum.chunk_every(@projects, 5)  do %>
            <div class="grid gap-4 auto-rows-min">
              <%= for project <- batch  do %>
                <div class="bg-white rounded-lg shadow">
                  <a href={"/projects/#{project.id}"}>
                    <img class="object-cover w-350  md:h-auto"

                    src={Venieri.Archives.Projects.image_url(project, 480)} alt="" />

            </a>
                  <div class="p-5">
                    <a href="#">
                      <h2 class="mb-2 font-bold tracking-tight text-gray-900">
                        <%= project.title %>
                      </h2>
                    </a>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        """
  end
end
