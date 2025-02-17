defmodule Venieri.EventFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Venieri.Archives.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_date: ~N[2025-01-24 17:41:00],
        show: true,
        start_date: ~N[2025-01-24 17:41:00],
        title: "some title",
        venue: "some venue"
      })
      |> Venieri.Archives.Events.create()

    event
  end
end
