defmodule Venieri.Archives.MediaTest do
  use Venieri.DataCase

  alias Venieri.Archives.Media

  describe "media" do
    alias Venieri.Archives.Models.Media, as: MediaModel

    import Venieri.MediaFixtures

    @invalid_attrs %{type: nil, width: nil, caption: nil, slug: nil, exernal_ref: nil, height: nil, old_id: nil, original_file: nil, meta_data: nil}

    test "list/0 returns all media" do
      media = media_fixture()
      assert Media.list() == [media]
    end

    test "get!/1 returns the media with given id" do
      media = media_fixture()
      assert Media.get!(media.id) == media
    end

    test "create/1 with valid data creates a media" do
      valid_attrs = %{type: "some type", width: 42, caption: "some caption",  exernal_ref: "some exernal_ref", height: 42, old_id: 42, original_file: "some original_file", meta_data: %{}}

      assert {:ok, %MediaModel{} = media} = Media.create(valid_attrs)
      assert media.type == "some type"
      assert media.width == 42
      assert media.caption == "some caption"
      assert media.slug == "some-caption"
      assert media.exernal_ref == "some exernal_ref"
      assert media.height == 42
      assert media.old_id == 42
      assert media.original_file == "some original_file"
      assert media.meta_data == %{}
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the media" do
      media = media_fixture()
      update_attrs = %{type: "some updated type", width: 43, caption: "some updated caption",  exernal_ref: "some updated exernal_ref", height: 43, old_id: 43, original_file: "some updated original_file", meta_data: %{}}

      assert {:ok, %MediaModel{} = media} = Media.update(media, update_attrs)
      assert media.type == "some updated type"
      assert media.width == 43
      assert media.caption == "some updated caption"
      assert media.slug == "some-caption"
      assert media.exernal_ref == "some updated exernal_ref"
      assert media.height == 43
      assert media.old_id == 43
      assert media.original_file == "some updated original_file"
      assert media.meta_data == %{}
    end

    test "update/2 with invalid data returns error changeset" do
      media = media_fixture()
      assert {:error, %Ecto.Changeset{}} = Media.update(media, @invalid_attrs)
      assert media == Media.get!(media.id)
    end

    test "delete/1 deletes the media" do
      media = media_fixture()
      assert {:ok, %MediaModel{}} = Media.delete(media)
      assert_raise Ecto.NoResultsError, fn -> Media.get!(media.id) end
    end

    test "change/1 returns a media changeset" do
      media = media_fixture()
      assert %Ecto.Changeset{} = Media.change(media)
    end
  end
end
