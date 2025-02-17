defmodule VenieriWeb.Archives.WorkLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Works

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [{SEO.key(), nil}]}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    work = Works.get!(id)
    {:noreply,
     socket
     |> SEO.assign(work)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:work, work)}
  end

  defp page_title(:show), do: "Show Work"
  defp page_title(:edit), do: "Edit Work"
end
