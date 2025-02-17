defmodule VenieriWeb.EventLiveTest do
  use VenieriWeb.ConnCase

  import Phoenix.LiveViewTest
  import Venieri.EventFixtures
  import Venieri.AccountsFixtures

  @create_attrs %{description: "some description", title: "some title", slug: "some slug", start_date: "2025-01-24T17:41:00", end_date: "2025-01-24T17:41:00", venue: "some venue", show: true}
  @update_attrs %{description: "some updated description", title: "some updated title", slug: "some updated slug", start_date: "2025-01-25T17:41:00", end_date: "2025-01-25T17:41:00", venue: "some updated venue", show: false}
  @invalid_attrs %{description: nil, title: nil, slug: nil, start_date: nil, end_date: nil, venue: nil, show: false}

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end

  describe "Index" do
    setup [:create_event]

    test "lists all events", %{conn: conn, event: event} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events")

      assert html =~ "Listing Events"
      assert html =~ event.description
    end

    test "saves new event", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events")

      assert index_live |> element("a", "New Event") |> render_click() =~
               "New Event"

      assert_patch(index_live, ~p"/archives/events/new")

      assert index_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event-form", event: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/events")

      html = render(index_live)
      assert html =~ "Event created successfully"
      assert html =~ "some description"
    end

    test "updates event in listing", %{conn: conn, event: event} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events")

      assert index_live |> element("#events-#{event.id} a", "Edit") |> render_click() =~
               "Edit Event"

      assert_patch(index_live, ~p"/archives/events/#{event}/edit")

      assert index_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#event-form", event: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/events")

      html = render(index_live)
      assert html =~ "Event updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes event in listing", %{conn: conn, event: event} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events")

      assert index_live |> element("#events-#{event.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#events-#{event.id}")
    end
  end

  describe "Show" do
    setup [:create_event]

    test "displays event", %{conn: conn, event: event} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events/#{event}")

      assert html =~ "Show Event"
      assert html =~ event.description
    end

    test "updates event within modal", %{conn: conn, event: event} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/events/#{event}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Event"

      assert_patch(show_live, ~p"/archives/events/#{event}/show/edit")

      assert show_live
             |> form("#event-form", event: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#event-form", event: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/events/#{event}")

      html = render(show_live)
      assert html =~ "Event updated successfully"
      assert html =~ "some updated description"
    end
  end
end
