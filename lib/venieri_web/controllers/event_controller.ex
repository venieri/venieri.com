defmodule VenieriWeb.EventController do
  use VenieriWeb, :controller

  alias Venieri.Repo
  alias Venieri.Archives.Events
  import VenieriWeb.Components.Navbar

  def show(conn, %{"id" => id}) do
    event = Events.get!(id)
    render(conn, :show, event: event)
  end

  def bio(conn, params) do
    shows =
      Repo.get_by(Venieri.Archives.Models.Tag, label: "Solo Show")
      |> Repo.preload(:events)
      |> then(& &1.events)
      # # |> Enum.map(& Repo.preload(&1,:media))
      # |> Enum.map(&IO.inspect/1)
      |> dbg()

    render(conn, :bio, shows: shows)
  end

end
