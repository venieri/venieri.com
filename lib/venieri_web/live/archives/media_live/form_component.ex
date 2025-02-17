defmodule VenieriWeb.Archives.MediaLive.FormComponent do
  use VenieriWeb, :live_component

  alias Venieri.Archives.Media


  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage media records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="media-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:caption]} type="text" label="Caption" />
        <.input field={@form[:slug]} type="text" label="Slug" />
        <.input field={@form[:exernal_ref]} type="text" label="Exernal ref" />
        <.input field={@form[:height]} type="number" label="Height" />
        <.input field={@form[:width]} type="number" label="Width" />
        <.input field={@form[:old_id]} type="number" label="Old" />
        <.input field={@form[:original_file]} type="text" label="Original file" />
        <.input field={@form[:type]} type="text" label="Type" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Media</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{media: media} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Media.change(media))
     end)}
  end

  @impl true
  def handle_event("validate", %{"media" => media_params}, socket) do
    changeset = Media.change(socket.assigns.media, media_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"media" => media_params}, socket) do
    save_media(socket, socket.assigns.action, media_params)
  end

  defp save_media(socket, :edit, media_params) do
    case Media.update(socket.assigns.media, media_params) do
      {:ok, media} ->
        notify_parent({:saved, media})

        {:noreply,
         socket
         |> put_flash(:info, "Media updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_media(socket, :new, media_params) do
    case Media.create(media_params) do
      {:ok, media} ->
        notify_parent({:saved, media})

        {:noreply,
         socket
         |> put_flash(:info, "Media created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
