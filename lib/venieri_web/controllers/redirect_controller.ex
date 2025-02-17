defmodule VenieriWeb.RedirectController do
  use VenieriWeb, :controller

  def redirect_to_posts(conn, _params) do
    conn
    |> Phoenix.Controller.redirect(to: ~p"/admin/posts")
    |> Plug.Conn.halt()
  end
end