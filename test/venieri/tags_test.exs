defmodule Venieri.ArchiveTest do
  use Venieri.DataCase

  alias Venieri.Archives.Tags

  describe "tags" do
    alias Venieri.Archives.Models.Tag

    import Venieri.ArchiveFixtures

    @invalid_attrs %{label: nil}

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      valid_attrs = %{label: "some label"}

      assert {:ok, %Tag{} = tag} = Tags.create(valid_attrs)
      assert tag.label == "some label"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      update_attrs = %{label: "some updated label"}

      assert {:ok, %Tag{} = tag} = Tags.update(tag, update_attrs)
      assert tag.label == "some updated label"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update(tag, @invalid_attrs)
      assert tag == Tags.get!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change(tag)
    end
  end
end
