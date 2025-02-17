defmodule VenieriWeb.Archives.EventLive.Show do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:event, Events.get!(id))}
  end

  # def render(assigns) do
  #   ~H"""
  #  #{}
  #   """
  # end

  defp page_title(:show), do: "Show Event"
  defp page_title(:edit), do: "Edit Event"
end
