defmodule VenieriWeb.MediaLiveTest do
  use VenieriWeb.ConnCase

  import Phoenix.LiveViewTest
  import Venieri.MediaFixtures
  import Venieri.AccountsFixtures

  @create_attrs %{type: "some type", width: 42, caption: "some caption",  exernal_ref: "some exernal_ref", height: 42, old_id: 42, original_file: "some original_file", meta_data: %{}}
  @update_attrs %{type: "some updated type", width: 43, caption: "some updated caption",  exernal_ref: "some updated exernal_ref", height: 43, old_id: 43, original_file: "some updated original_file", meta_data: %{}}
  @invalid_attrs %{type: nil, width: nil, caption: nil, slug: nil, exernal_ref: nil, height: nil, old_id: nil, original_file: nil, meta_data: nil}

  defp create_media(_) do
    media = media_fixture()
    %{media: media}
  end

  describe "Index" do
    setup [:create_media]

    test "lists all media", %{conn: conn, media: media} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media")

      assert html =~ "Listing Media"
      assert html =~ media.type
    end

    test "saves new media", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media")

      assert index_live |> element("a", "New Media") |> render_click() =~
               "New Media"

      assert_patch(index_live, ~p"/archives/media/new")

      assert index_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#media-form", media: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/media")

      html = render(index_live)
      assert html =~ "Media created successfully"
      assert html =~ "some type"
    end

    test "updates media in listing", %{conn: conn, media: media} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media")

      assert index_live |> element("#media-#{media.id} a", "Edit") |> render_click() =~
               "Edit Media"

      assert_patch(index_live, ~p"/archives/media/#{media}/edit")

      assert index_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#media-form", media: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/media")

      html = render(index_live)
      assert html =~ "Media updated successfully"
      assert html =~ "some updated type"
    end

    test "deletes media in listing", %{conn: conn, media: media} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media")

      assert index_live |> element("#media-#{media.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#media-#{media.id}")
    end
  end

  describe "Show" do
    setup [:create_media]

    test "displays media", %{conn: conn, media: media} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media/#{media}")

      assert html =~ "Show Media"
      assert html =~ media.type
    end

    test "updates media within modal", %{conn: conn, media: media} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/media/#{media}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Media"

      assert_patch(show_live, ~p"/archives/media/#{media}/show/edit")

      assert show_live
             |> form("#media-form", media: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#media-form", media: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/media/#{media}")

      html = render(show_live)
      assert html =~ "Media updated successfully"
      assert html =~ "some updated type"
    end
  end
end
