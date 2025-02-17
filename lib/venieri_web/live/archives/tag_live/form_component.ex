defmodule VenieriWeb.Archives.TagLive.FormComponent do
  use VenieriWeb, :live_component

  alias Venieri.Archives.Tags

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage tag records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tag-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:label]} type="text" label="Label" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tag</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tag: tag} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Tags.change(tag))
     end)}
  end

  @impl true
  def handle_event("validate", %{"tag" => tag_params}, socket) do
    changeset = Tags.change(socket.assigns.tag, tag_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"tag" => tag_params}, socket) do
    save_tag(socket, socket.assigns.action, tag_params)
  end

  defp save_tag(socket, :edit, tag_params) do
    case Tags.update(socket.assigns.tag, tag_params) do
      {:ok, tag} ->
        notify_parent({:saved, tag})

        {:noreply,
         socket
         |> put_flash(:info, "Tag updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_tag(socket, :new, tag_params) do
    case Tags.create(tag_params) do
      {:ok, tag} ->
        notify_parent({:saved, tag})

        {:noreply,
         socket
         |> put_flash(:info, "Tag created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
