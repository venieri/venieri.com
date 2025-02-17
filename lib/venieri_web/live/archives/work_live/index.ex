defmodule VenieriWeb.Archives.WorkLive.Index do
  use VenieriWeb, :live_view

  alias Venieri.Archives.Works
  alias Venieri.Archives.Models.Work

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket
    |> SEO.assign(%{title: "List of work"}), :works, Works.list()), temporary_assigns: [{SEO.key(), nil}]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Work")
    |> assign(:work, Works.get!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Work")
    |> assign(:work, %Work{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Works")
    |> assign(:work, nil)
  end

  @impl true
  def handle_info({VenieriWeb.Archives.WorkLive.FormComponent, {:saved, work}}, socket) do
    {:noreply, stream_insert(socket, :works, work)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    work = Works.get!(id)
    {:ok, _} = Works.delete(work)

    {:noreply, stream_delete(socket, :works, work)}
  end
end
