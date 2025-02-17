defmodule VenieriWeb.Archives.MediaLive.Index do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Media
  alias Venieri.Archives.Models.Media, as: MediaModel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :media_collection, Media.list())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Media")
    |> assign(:media, Media.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Media")
    |> assign(:media, %MediaModel{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Media")
    |> assign(:media, nil)
  end

  @impl true
  def handle_info({VenieriWeb.Archives.MediaLive.FormComponent, {:saved, media}}, socket) do
    {:noreply, stream_insert(socket, :media_collection, media)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    media = Media.get!(id)
    {:ok, _} = Media.delete(media)

    {:noreply, stream_delete(socket, :media_collection, media)}
  end
end
