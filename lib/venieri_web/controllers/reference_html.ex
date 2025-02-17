defmodule VenieriWeb.ReferenceHTML do
  use VenieriWeb, :html

  embed_templates "reference_html/*"

  @doc """
  Renders a reference form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def reference_form(assigns)
end
