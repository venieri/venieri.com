defmodule Venieri.ArchiveFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archive` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        label: "some label"
      })
      |> Venieri.Archives.Tags.create()

    tag
  end
end
