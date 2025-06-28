defmodule VenieriWeb.Admin.Filters.ProjectFilter do
  @moduledoc """
  Implementation of the `Backpex.Filters.MultiSelect` behaviour.
  """

  use Backpex.Filters.Select

  alias Venieri.Archives.Models.Project
  alias Venieri.Archives.Models.Work
  alias Venieri.Repo

  @impl Backpex.Filter
  def label, do: "Project"

  @impl Backpex.Filters.Select
  def prompt, do: "Select project ..."

  @impl Backpex.Filters.Select
  def options do
    query =
      from w in Work,
        join: p in Project,
        on: w.project_id == p.id,
        distinct: p.title,
        select: {p.title, p.id}

    Repo.all(query)
  end
end
