defmodule Venieri.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archives.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        show: true,
        statement: "some statement",
        title: "some title"
      })
      |> Venieri.Archives.Projects.create()

    project
  end
end
