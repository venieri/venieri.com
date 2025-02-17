defmodule Venieri.EventsTest do
  use Venieri.DataCase

  alias Venieri.Archives.Events

  describe "events" do
    alias Venieri.Archives.Models.Event

    import Venieri.EventFixtures

    @invalid_attrs %{description: nil, title: nil, slug: nil, start_date: nil, end_date: nil, venue: nil, show: nil}

    test "list/0 returns all events" do
      event = event_fixture()
      assert Events.list() == [event]
    end

    test "get!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get!(event.id) == event
    end

    test "create/1 with valid data creates a event" do
      valid_attrs = %{description: "some description", title: "some title",  start_date: ~N[2025-01-24 17:41:00], end_date: ~N[2025-01-24 17:41:00], venue: "some venue", show: true}

      assert {:ok, %Event{} = event} = Events.create(valid_attrs)
      assert event.description == "some description"
      assert event.title == "some title"
      assert event.slug == "some-title-some-venue"
      assert event.start_date == ~N[2025-01-24 17:41:00]
      assert event.end_date == ~N[2025-01-24 17:41:00]
      assert event.venue == "some venue"
      assert event.show == true
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title",  start_date: ~N[2025-01-25 17:41:00], end_date: ~N[2025-01-25 17:41:00], venue: "some updated venue", show: false}

      assert {:ok, %Event{} = event} = Events.update(event, update_attrs)
      assert event.description == "some updated description"
      assert event.title == "some updated title"
      assert event.slug == "some-title-some-venue"
      assert event.start_date == ~N[2025-01-25 17:41:00]
      assert event.end_date == ~N[2025-01-25 17:41:00]
      assert event.venue == "some updated venue"
      assert event.show == false
    end

    test "update/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update(event, @invalid_attrs)
      assert event == Events.get!(event.id)
    end

    test "delete/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get!(event.id) end
    end

    test "change/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change(event)
    end
  end
end
