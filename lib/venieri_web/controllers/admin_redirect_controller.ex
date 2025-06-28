defmodule VenieriWeb.Admin.RedirectController do
  use VenieriWeb, :controller

  def redirect_to_posts(conn, _params) do
    conn
    |> Phoenix.Controller.redirect(to: ~p"/admin/projects")
    |> Plug.Conn.halt()
  end
end
