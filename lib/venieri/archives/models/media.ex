defmodule Venieri.Archives.Models.Media do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.MediaSlug
  alias Venieri.Archives.Models.WorkMedia
  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.EventMedia
  alias Venieri.Archives.Models.Event
  @derive Jason.Encoder
  schema "archives_media" do
    field :type, :string
    field :width, :integer
    field :caption, :string
    field :slug, MediaSlug.Type
    field :exernal_ref, :string
    field :height, :integer
    field :old_id, :integer
    field :original_file, :string
    field :display_file, :string
    field :meta_data, :map

      many_to_many :works, Work, join_through: WorkMedia, on_replace: :delete
      many_to_many :events, Event, join_through: EventMedia, on_replace: :delete
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media, attrs, metadata \\ [])
  def changeset(media, %{"meta_data" => meta_data} = attrs, metadata) when is_binary(meta_data) do
    IO.inspect(attrs, label: "correct attrs")
    attrs =
      attrs
      |> Map.update!("meta_data", fn meta_data-> Jason.decode!(meta_data) end)
    changeset(media, attrs, metadata)
  end

  def changeset(media, attrs,  _metadata) do
    IO.inspect(attrs, label: "attrs")
    media
    |> cast(attrs, [:caption, :slug, :exernal_ref, :height, :width, :old_id, :original_file, :display_file,:type, :meta_data])
    |> validate_required([:original_file])
    |> validate_change(:original_file, fn
      :original_file, "too_many_files" ->
        [original_file: "has to be exactly one"]

      :original_file, "" ->
        [original_file: "can't be blank"]

      :original_file, _original_file ->
        []
    end)
    |> MediaSlug.maybe_generate_slug()
    |> unique_constraint(:slug)
  end
end
