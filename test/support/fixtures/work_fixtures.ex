defmodule Venieri.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archives.Works` context.
  """

  @doc """
  Generate a work.
  """
  def work_fixture(attrs \\ %{}) do
    {:ok, work} =
      attrs
      |> Enum.into(%{
        year: 1991,
        description: "some description",
        material: "some material",
        show: true,
        size: "some size",
        title: "some title"
      })
      |> Venieri.Archives.Works.create()

    work
  end
end
