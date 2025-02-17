defmodule  VenieriWeb.Admin.ResourceActions.Rotate do
  use Backpex.ResourceAction

  import Ecto.Changeset

  @impl Backpex.ResourceAction
  def label, do: "Rotate"

  @impl Backpex.ResourceAction
  def title, do: "Rotate"

  # you can reuse Backpex fields in the field definition
  @impl Backpex.ResourceAction
  def fields do
      [
          original_file: %{
              module: Backpex.Fields.Text,
              label: "File",
              type: :string
          }
      ]
  end

  @impl Backpex.ResourceAction
  def changeset(change, attrs, _metadata \\[]) do
      change
      |> cast(attrs, [:original_file])
      |> validate_required([:original_file])
  end

  @impl Backpex.ResourceAction
  def handle(socket, _data) do
    # Send mail

    # We suppose there was no error.
    # socket = Phoenix.LiveView.put_flash(socket, :info, "An email has been successfully sent to the specified users.")

    {:ok, socket}
  end
end
