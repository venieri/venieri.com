defmodule VenieriWeb.PageController do
  use VenieriWeb, :controller

  alias Venieri.Repo
  alias Venieri.Archives.Projects
  alias Venieri.Archives.Events
  alias Venieri.Archives.References

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def bio(conn, _params) do
    solo_shows = Events.events_by_tag("Solo Show")
    group_shows = Events.events_by_tag("Group Show")
    references =
      References.list()
      |> Enum.sort_by(& &1.publication_date, :desc)
      render(conn, :bio,
        solo_shows: solo_shows,
        group_shows: group_shows,
        references: references
        )
  end

  def events(conn, params) do
    {:ok, {events, meta}} = Events.page(params)
    render(conn, :events, events: events, meta: meta)
  end

  def event(conn, %{"id" => id}) do
    event = Events.get!(id)
    render(conn, :show, event: event)
  end

  def projects(conn, _params) do
    projects = Projects.list()
    render(conn, :projects, projects: projects)
  end

  def project(conn, %{"id" => id}) do
    dbg(%{"id" => id})
    project = Projects.get!(id)
    render(conn, :project, project: project |> Repo.preload([:works]))
  end

  def virtual_world(conn, _params) do
    render(
      conn
      |> put_layout(false)
      |> put_root_layout(false),
      :virtual_world
    )
  end

  def test(conn, _params) do
    render(
      conn,
      # |> put_layout(false)
      # |> put_root_layout(false),
      :test
    )
  end





  def test(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :test, layout: false)
    text(conn, "From messenger ")
  end
end
