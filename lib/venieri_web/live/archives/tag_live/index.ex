defmodule VenieriWeb.Archives.TagLive.Index do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Tags
  alias Venieri.Archives.Models.Tag
  alias VenieriWeb.Archives.TagLive.FormComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tags, Tags.list())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tag")
    |> assign(:tag, Tags.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tag")
    |> assign(:tag, %Tag{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tags")
    |> assign(:tag, nil)
  end

  @impl true
  def handle_info({FormComponent, {:saved, tag}}, socket) do
    {:noreply, stream_insert(socket, :tags, tag)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tag = Tags.get!(id)
    {:ok, _} = Tags.delete(tag)

    {:noreply, stream_delete(socket, :tags, tag)}
  end
end
