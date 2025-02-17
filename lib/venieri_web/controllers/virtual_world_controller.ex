defmodule  VenieriWeb.VirtualWorldController do
  use Phoenix.Controller,  formats: [:html]

  def virtual_world(conn, _) do
    render(
      conn
      |> put_layout(false)
      |> put_root_layout(false),
      :virtual_world
    )
  end

end
