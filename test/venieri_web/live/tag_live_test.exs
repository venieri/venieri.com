defmodule VenieriWeb.TagLiveTest do
  use VenieriWeb.ConnCase

  import Phoenix.LiveViewTest
  import Venieri.ArchiveFixtures
  import Venieri.AccountsFixtures

  @create_attrs %{label: "some label"}
  @update_attrs %{label: "some updated label"}
  @invalid_attrs %{label: nil}

  defp create_tag(_) do
    tag = tag_fixture()
    %{tag: tag}
  end

  describe "Index" do
    setup [:create_tag]

    test "lists all tags", %{conn: conn, tag: tag} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live( ~p"/archives/tags")

      assert html =~ "Listing Tags"
      assert html =~ tag.label
    end

    test "saves new tag", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/tags")

      assert index_live |> element("a", "New Tag") |> render_click() =~
               "New Tag"

      assert_patch(index_live, ~p"/archives/tags/new")

      assert index_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tag-form", tag: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/tags")

      html = render(index_live)
      assert html =~ "Tag created successfully"
      assert html =~ "some label"
    end

    test "updates tag in listing", %{conn: conn, tag: tag} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live( ~p"/archives/tags")

      assert index_live |> element("#tags-#{tag.id} a", "Edit") |> render_click() =~
               "Edit Tag"

      assert_patch(index_live, ~p"/archives/tags/#{tag}/edit")

      assert index_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#tag-form", tag: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/tags")

      html = render(index_live)
      assert html =~ "Tag updated successfully"
      assert html =~ "some updated label"
    end

    test "deletes tag in listing", %{conn: conn, tag: tag} do
      {:ok, index_live, _html} =
      conn
      |> log_in_user(user_fixture())
      |> live(~p"/archives/tags")
      assert index_live |> element("#tags-#{tag.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tags-#{tag.id}")
    end
  end

  describe "Show" do
    setup [:create_tag]

    test "displays tag", %{conn: conn, tag: tag} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/tags/#{tag}")

      assert html =~ "Show Tag"
      assert html =~ tag.label
    end

    test "updates tag within modal", %{conn: conn, tag: tag} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/tags/#{tag}")


      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tag"

      assert_patch(show_live, ~p"/archives/tags/#{tag}/show/edit")

      assert show_live
             |> form("#tag-form", tag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#tag-form", tag: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/tags/#{tag}")

      html = render(show_live)
      assert html =~ "Tag updated successfully"
      assert html =~ "some updated label"
    end
  end
end
