defmodule VenieriWeb.Archives.WorkLive.FormComponent do
  use VenieriWeb, :live_component

  alias Venieri.Archives.Works


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage work records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="work-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:year]} type="number" label="Year" />
        <.input field={@form[:material]} type="text" label="Material" />
        <.input field={@form[:size]} type="text" label="Size" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:show]} type="checkbox" label="Show" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Work</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{work: work} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Works.change(work))
     end)}
  end

  @impl true
  def handle_event("validate", %{"work" => work_params}, socket) do
    changeset = Works.change(socket.assigns.work, work_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"work" => work_params}, socket) do
    save_work(socket, socket.assigns.action, work_params)
  end

  defp save_work(socket, :edit, work_params) do
    case Works.update(socket.assigns.work, work_params) do
      {:ok, work} ->
        notify_parent({:saved, work})

        {:noreply,
         socket
         |> put_flash(:info, "Work updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_work(socket, :new, work_params) do
    case Works.create(work_params) do
      {:ok, work} ->
        notify_parent({:saved, work})

        {:noreply,
         socket
         |> put_flash(:info, "Work created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
