defmodule VenieriWeb.ReferenceControllerTest do
  use VenieriWeb.ConnCase

  import Venieri.ReferencesFixtures

  @create_attrs %{description: "some description", title: "some title", publication_date: ~D[2025-02-02], publication: "some publication", authors: "some authors", article_url: "some article_url", uploaded_file: "some uploaded_file"}
  @update_attrs %{description: "some updated description", title: "some updated title", publication_date: ~D[2025-02-03], publication: "some updated publication", authors: "some updated authors", article_url: "some updated article_url", uploaded_file: "some updated uploaded_file"}
  @invalid_attrs %{description: nil, title: nil, publication_date: nil, publication: nil, authors: nil, article_url: nil, uploaded_file: nil}

  describe "index" do
    test "lists all archives/references", %{conn: conn} do
      conn = get(conn, ~p"/archives/references")
      assert html_response(conn, 200) =~ "Listing Archives references"
    end
  end

  describe "new reference" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/archives/references/new")
      assert html_response(conn, 200) =~ "New Reference"
    end
  end

  describe "create reference" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/archives/references", reference: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/archives/references/#{id}"

      conn = get(conn, ~p"/archives/references/#{id}")
      assert html_response(conn, 200) =~ "Reference #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/archives/references", reference: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Reference"
    end
  end

  describe "edit reference" do
    setup [:create_reference]

    test "renders form for editing chosen reference", %{conn: conn, reference: reference} do
      conn = get(conn, ~p"/archives/references/#{reference}/edit")
      assert html_response(conn, 200) =~ "Edit Reference"
    end
  end

  describe "update reference" do
    setup [:create_reference]

    test "redirects when data is valid", %{conn: conn, reference: reference} do
      conn = put(conn, ~p"/archives/references/#{reference}", reference: @update_attrs)
      assert redirected_to(conn) == ~p"/archives/references/#{reference}"

      conn = get(conn, ~p"/archives/references/#{reference}")
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, reference: reference} do
      conn = put(conn, ~p"/archives/references/#{reference}", reference: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Reference"
    end
  end

  describe "delete reference" do
    setup [:create_reference]

    test "deletes chosen reference", %{conn: conn, reference: reference} do
      conn = delete(conn, ~p"/archives/references/#{reference}")
      assert redirected_to(conn) == ~p"/archives/references"

      assert_error_sent 404, fn ->
        get(conn, ~p"/archives/references/#{reference}")
      end
    end
  end

  defp create_reference(_) do
    reference = reference_fixture()
    %{reference: reference}
  end
end
