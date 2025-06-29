defmodule VenieriWeb.ProjectLive.Show do
  use VenieriWeb, :live_view
  import VenieriWeb.Components.Navbar

  alias Venieri.Archives.Projects
  alias Venieri.Repo
  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    project =
      Projects.get!(id)
      |> Repo.preload([:works])
    {:noreply,
     socket
     |> assign(:page_title, project.title)
     |> assign(:project, project)}
  end

end
