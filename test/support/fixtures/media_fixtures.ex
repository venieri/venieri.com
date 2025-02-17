defmodule Venieri.MediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archives.Media` context.
  """

  @doc """
  Generate a media.
  """
  def media_fixture(attrs \\ %{}) do
    {:ok, media} =
      attrs
      |> Enum.into(%{
        caption: "some caption",
        exernal_ref: "some exernal_ref",
        height: 42,
        meta_data: %{},
        old_id: 42,
        original_file: "some original_file",
        type: "some type",
        width: 42
      })
      |> Venieri.Archives.Media.create()
    media
  end
end
