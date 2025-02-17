defmodule VenieriWeb.ProjectLiveTest do
  use VenieriWeb.ConnCase

  import Phoenix.LiveViewTest
  import Venieri.ProjectsFixtures
  import Venieri.AccountsFixtures
  @create_attrs %{description: "some description", title: "some title", slug: "some slug", statement: "some statement", show: true}
  @update_attrs %{description: "some updated description", title: "some updated title", slug: "some updated slug", statement: "some updated statement", show: false}
  @invalid_attrs %{description: nil, title: nil, slug: nil, statement: nil, show: false}

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end

  describe "Index" do
    setup [:create_project]

    test "lists all projects", %{conn: conn, project: project} do
      {:ok, _index_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects")

      assert html =~ "Listing Projects"
      assert html =~ project.description
    end

    test "saves new project", %{conn: conn} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects")

      assert index_live |> element("a", "New Project") |> render_click() =~
               "New Project"

      assert_patch(index_live, ~p"/archives/projects/new")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project-form", project: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/projects")

      html = render(index_live)
      assert html =~ "Project created successfully"
      assert html =~ "some description"
    end

    test "updates project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects")

      assert index_live |> element("#projects-#{project.id} a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(index_live, ~p"/archives/projects/#{project}/edit")

      assert index_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#project-form", project: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/archives/projects")

      html = render(index_live)
      assert html =~ "Project updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes project in listing", %{conn: conn, project: project} do
      {:ok, index_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects")

      assert index_live |> element("#projects-#{project.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#projects-#{project.id}")
    end
  end

  describe "Show" do
    setup [:create_project]

    test "displays project", %{conn: conn, project: project} do
      {:ok, _show_live, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects/#{project}")

      assert html =~ "Show Project"
      assert html =~ project.description
    end

    test "updates project within modal", %{conn: conn, project: project} do
      {:ok, show_live, _html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/archives/projects/#{project}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Project"

      assert_patch(show_live, ~p"/archives/projects/#{project}/show/edit")

      assert show_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#project-form", project: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/archives/projects/#{project}")

      html = render(show_live)
      assert html =~ "Project updated successfully"
      assert html =~ "some updated description"
    end
  end
end
