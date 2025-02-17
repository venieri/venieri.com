defmodule Venieri.ReferencesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archives` context.
  """

  @doc """
  Generate a reference.
  """
  def reference_fixture(attrs \\ %{}) do
    {:ok, reference} =
      attrs
      |> Enum.into(%{
        article_url: "some article_url",
        authors: "some authors",
        description: "some description",
        publication: "some publication",
        publication_date: ~D[2025-02-02],
        title: "some title",
        uploaded_file: "some uploaded_file"
      })
      |> Venieri.Archives.References.create()

    reference
  end
end
