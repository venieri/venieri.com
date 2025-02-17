defmodule Venieri.Archives.WorksTest do
  use Venieri.DataCase

  alias Venieri.Archives.Works

  describe "works" do
    alias Venieri.Archives.Models.Work

    import Venieri.WorkFixtures

    @invalid_attrs %{size: nil, year: nil, description: nil, title: nil, slug: nil, material: nil, show: nil}

    test "list/0 returns all works" do
      work = work_fixture()
      assert Works.list() == [work]
    end

    test "get_work!/1 returns the work with given id" do
      work = work_fixture()
      assert Works.get!(work.id) == work
    end

    test "create_work/1 with valid data creates a work" do
      valid_attrs = %{size: "some size", year: 1991, description: "some description", title: "some title", slug: "some-title", material: "some material", show: true}

      assert {:ok, %Work{} = work} = Works.create(valid_attrs)
      assert work.size == "some size"
      assert work.year ==  1991
      assert work.description == "some description"
      assert work.title == "some title"
      assert work.slug == "some-title-1991"
      assert work.material == "some material"
      assert work.show == true
    end

    test "create_work/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Works.create(@invalid_attrs)
    end

    test "update_work/2 with valid data updates the work" do
      work = work_fixture()
      update_attrs = %{size: "some updated size", year: 1992, description: "some updated description", title: "some updated title", material: "some updated material", show: false}

      assert {:ok, %Work{} = work} = Works.update(work, update_attrs)
      assert work.size == "some updated size"
      assert work.year == 1992
      assert work.description == "some updated description"
      assert work.title == "some updated title"
      assert work.slug == "some-title-1991"
      assert work.material == "some updated material"
      assert work.show == false
    end

    test "update_work/2 with invalid data returns error changeset" do
      work = work_fixture()
      assert {:error, %Ecto.Changeset{}} = Works.update(work, @invalid_attrs)
      assert work == Works.get!(work.id)
    end

    test "delete_work/1 deletes the work" do
      work = work_fixture()
      assert {:ok, %Work{}} = Works.delete(work)
      assert_raise Ecto.NoResultsError, fn -> Works.get!(work.id) end
    end

    test "change_work/1 returns a work changeset" do
      work = work_fixture()
      assert %Ecto.Changeset{} = Works.change(work)
    end
  end
end
