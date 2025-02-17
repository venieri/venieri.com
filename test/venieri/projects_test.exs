defmodule Venieri.ProjectsTest do
  use Venieri.DataCase

  alias Venieri.Archives.Projects

  describe "projects" do
    alias Venieri.Archives.Models.Project

    import Venieri.ProjectsFixtures

    @invalid_attrs %{description: nil, title: nil, slug: nil, statement: nil, show: nil}

    test "list/0 returns all projects" do
      project = project_fixture()
      assert Projects.list() == [project]
    end

    test "get!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get!(project.id) == project
    end

    test "create/1 with valid data creates a project" do
      valid_attrs = %{description: "some description", title: "some title", slug: "some-title", statement: "some statement", show: true}

      assert {:ok, %Project{} = project} = Projects.create(valid_attrs)
      assert project.description == "some description"
      assert project.title == "some title"
      assert project.slug == "some-title"
      assert project.statement == "some statement"
      assert project.show == true
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", slug: "some-updated-title", statement: "some updated statement", show: false}

      assert {:ok, %Project{} = project} = Projects.update(project, update_attrs)
      assert project.description == "some updated description"
      assert project.title == "some updated title"
      assert project.slug == "some-updated-title"
      assert project.statement == "some updated statement"
      assert project.show == false
    end

    test "update/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update(project, @invalid_attrs)
      assert project == Projects.get!(project.id)
    end

    test "delete/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get!(project.id) end
    end

    test "change/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change(project)
    end
  end
end
