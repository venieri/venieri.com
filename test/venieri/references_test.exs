defmodule Venieri.ArchivesTest do
  use Venieri.DataCase

  alias Venieri.Archives

  describe "archivess" do
    alias Venieri.Archives.References
    alias Venieri.Archives.Models.Reference

    import Venieri.ReferencesFixtures

    @invalid_attrs %{description: nil, title: nil, publication_date: nil, publication: nil, authors: nil, article_url: nil, uploaded_file: nil}

    test "list/0 returns all archivess" do
      reference = reference_fixture()
      assert References.list() == [reference]
    end

    test "get!/1 returns the reference with given id" do
      reference = reference_fixture()
      assert References.get!(reference.id) == reference
    end

    test "create/1 with valid data creates a reference" do
      valid_attrs = %{description: "some description", title: "some title", publication_date: ~D[2025-02-02], publication: "some publication", authors: "some authors", article_url: "some article_url", uploaded_file: "some uploaded_file"}

      assert {:ok, %Reference{} = reference} = References.create(valid_attrs)
      assert reference.description == "some description"
      assert reference.title == "some title"
      assert reference.publication_date == ~D[2025-02-02]
      assert reference.publication == "some publication"
      assert reference.authors == "some authors"
      assert reference.article_url == "some article_url"
      assert reference.uploaded_file == "some uploaded_file"
    end

    test "create/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = References.create(@invalid_attrs)
    end

    test "update/2 with valid data updates the reference" do
      reference = reference_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", publication_date: ~D[2025-02-03], publication: "some updated publication", authors: "some updated authors", article_url: "some updated article_url", uploaded_file: "some updated uploaded_file"}

      assert {:ok, %Reference{} = reference} = References.update(reference, update_attrs)
      assert reference.description == "some updated description"
      assert reference.title == "some updated title"
      assert reference.publication_date == ~D[2025-02-03]
      assert reference.publication == "some updated publication"
      assert reference.authors == "some updated authors"
      assert reference.article_url == "some updated article_url"
      assert reference.uploaded_file == "some updated uploaded_file"
    end

    test "update/2 with invalid data returns error changeset" do
      reference = reference_fixture()
      assert {:error, %Ecto.Changeset{}} = References.update(reference, @invalid_attrs)
      assert reference == References.get!(reference.id)
    end

    test "delete/1 deletes the reference" do
      reference = reference_fixture()
      assert {:ok, %Reference{}} = References.delete(reference)
      assert_raise Ecto.NoResultsError, fn -> References.get!(reference.id) end
    end

    test "change/1 returns a reference changeset" do
      reference = reference_fixture()
      assert %Ecto.Changeset{} = References.change(reference)
    end
  end
end
