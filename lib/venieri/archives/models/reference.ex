defmodule Venieri.Archives.Models.Reference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "references" do
    field(:description, :string)
    field(:title, :string)
    field(:publication_date, :date)
    field(:edition, :string)
    field(:publication, :string)
    field(:authors, :string)
    field(:article_url, :string)
    field(:uploaded_file, :string)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(reference, attrs, _meta \\ []) do
    reference
    |> cast(attrs, [
      :title,
      :description,
      :publication_date,
      :publication,
      :authors,
      :article_url,
      :edition,
      :uploaded_file
    ])
    |> validate_required([:title])
  end
end
