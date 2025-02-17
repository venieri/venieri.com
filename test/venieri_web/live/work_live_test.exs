defmodule VenieriWeb.WorkLiveTest do
  use VenieriWeb.ConnCase

  import Phoenix.LiveViewTest
  import Venieri.WorkFixtures
  import Venieri.AccountsFixtures

  @create_attrs %{size: "some size", year: 1991, description: "some description", title: "some title", slug: "some-title", material: "some material", show: true}
  @update_attrs %{size: "some updated size", year: 1992, description: "some updated description", title: "some-updated-title", slug: "some updated slug", material: "some updated material", show: false}
  @invalid_attrs %{size: nil, year: nil, description: nil, title: nil, slug: nil, material: nil, show: false}

  defp create_work(_) do
    work = work_fixture()
    %{work: work}
  end

  describe "Index" do
    setup [:create_work]

    test "lists all works", %{conn: conn, work: work} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works")

      assert html =~ "Listing Works"
      assert html =~ work.size
    end

    test "saves new work", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works")

      assert index_live |> element("a", "New Work") |> render_click() =~
               "New Work"

      assert_patch(index_live, ~p"/archives/works/new")

      assert index_live
             |> form("#work-form", work: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#work-form", work: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/works")

      html = render(index_live)
      assert html =~ "Work created successfully"
      assert html =~ "some size"
    end

    test "updates work in listing", %{conn: conn, work: work} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works")

      assert index_live |> element("#works-#{work.id} a", "Edit") |> render_click() =~
               "Edit Work"

      assert_patch(index_live, ~p"/archives/works/#{work}/edit")

      assert index_live
             |> form("#work-form", work: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#work-form", work: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/works")

      html = render(index_live)
      assert html =~ "Work updated successfully"
      assert html =~ "some updated size"
    end

    test "deletes work in listing", %{conn: conn, work: work} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works")

      assert index_live |> element("#works-#{work.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#works-#{work.id}")
    end
  end

  describe "Show" do
    setup [:create_work]

    test "displays work", %{conn: conn, work: work} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works/#{work}")

      assert html =~ "Show Work"
      assert html =~ work.size
    end

    test "updates work within modal", %{conn: conn, work: work} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/works/#{work}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Work"

      assert_patch(show_live, ~p"/archives/works/#{work}/show/edit")

      assert show_live
             |> form("#work-form", work: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#work-form", work: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/works/#{work}")

      html = render(show_live)
      assert html =~ "Work updated successfully"
      assert html =~ "some updated size"
    end
  end
end
