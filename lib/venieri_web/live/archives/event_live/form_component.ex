defmodule VenieriWeb.Archives.EventLive.FormComponent do
  use VenieriWeb, :live_component

  alias Venieri.Archives.Events

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:start_date]} type="datetime-local" label="Start date" />
        <.input field={@form[:end_date]} type="datetime-local" label="End date" />
        <.input field={@form[:venue]} type="text" label="Venue" />
        <.input field={@form[:show]} type="checkbox" label="Show" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Events.change(event))
     end)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset = Events.change(socket.assigns.event, event_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Events.update(socket.assigns.event, event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Events.create(event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
