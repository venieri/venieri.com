defmodule Venieri.Archives.Models.Media do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.MediaSlug
  # alias Venieri.Archives.Models.WorkMedia
  alias Venieri.Archives.Models.Work
  # alias Venieri.Archives.Models.EventMedia
  # alias Venieri.Archives.Models.Event
  @required_fields ~w(caption slug)a
  @optional_fields ~w(type uploaded_file external_uri embeded_html width height meta_data old_id)a
  @derive Jason.Encoder
  schema "media" do
    field :type, :string
    field :caption, :string
    field :slug, MediaSlug.Type
    field :old_id, :integer

    field :uploaded_file, :string
    field :external_uri, :string
    field :embeded_html, :string

    field :width, :integer
    field :height, :integer
    field :meta_data, :map, default: %{}

    field :icon, :string, virtual: true

    many_to_many(:works, Work, join_through: WorkMedia, on_replace: :delete)
    # many_to_many(:events, Event, join_through: EventMedia, on_replace: :delete)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(media, attrs, metadata \\ [])

  def changeset(media, %{"meta_data" => meta_data} = attrs, metadata) when is_binary(meta_data) do
    IO.inspect(attrs, label: "correct attrs")

    attrs =
      attrs
      |> Map.update!("meta_data", fn meta_data -> Jason.decode!(meta_data) end)

    changeset(media, attrs, metadata)
  end

  # 13th Month Sculpture in the Ano Mera garden

  def changeset(media, attrs, _metadata) do
    IO.inspect(attrs, label: "attrs")

    media
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> MediaSlug.maybe_generate_slug()
    |> validate_required(@required_fields)
    |> unique_slug_constraint()

    # |> validate_change(:original_file, fn
    #   :original_file, "too_many_files" ->
    #     [original_file: "has to be exactly one"]

    #   :original_file, "" ->
    #     [original_file: "can't be blank"]

    #   :original_file, _original_file ->
    #     []
    # end)
    # |> check_constraint(:media_source,
    #   name: :uri_or_image,
    #   message: "upload an image or add a video uri"
    # )
  end

  def unique_slug_constraint(changeset, opts \\ []) do
    changeset
    |> MediaSlug.unique_constraint(opts)
  end
end

defimpl String.Chars, for: Venieri.Archives.Models.Media do
  def to_string(%Venieri.Archives.Models.Media{} = media) do
    Venieri.Entity.url(media, 480)
  end

  # def to_string({%Venieri.Archives.Models.Media{} = media, size}) do
  #   Venieri.Entity.url(media, size)
  # end
end

# defimpl Venieri.Entity, for: Venieri.Archives.Models.Media do
#   def url(media, width \\ nil, extension \\ "avif") do
#       with_postfix =
#         if width == nil do
#           ""
#         else
#           "-#{width}"
#         end

#       cond do
#         media.meta_data != nil ->
#           small_image = "#{media.slug}#{with_postfix}.#{extension}"

#         # Phoenix.VerifiedRoutes.static_url(
#         #   VenieriWeb.Endpoint,
#           "/" <> Path.join(["media", small_image])
#         # )
#         media.original_file != nil ->
#           Phoenix.VerifiedRoutes.static_url(
#             VenieriWeb.Endpoint,
#             "/" <> Path.join(["uploads", "media", media.original_file])
#           )
#         media.video_uri != nil ->
#           media.video_uri
#         true ->
#           ""
#         end
#   end
# end

# defimpl Venieri.Entity, for: Venieri.Archives.Models.Media do

#   def url(media, width \\ nil), for: Venieri.Archives.Models.Media do
#       with_postfix =
#         if width == nil do
#           ""
#         else
#           "-#{width}"
#         end

#       cond do
#         media.meta_data != nil ->
#           small_image = "#{media.slug}#{with_postfix}.avif"

#         Phoenix.VerifiedRoutes.static_url(
#           VenieriWeb.Endpoint,
#           "/" <> Path.join(["media", small_image])
#         )
#         media.original_file != nil ->
#           Phoenix.VerifiedRoutes.static_url(
#             VenieriWeb.Endpoint,
#             "/" <> Path.join(["uploads", "media", media.original_file])
#           )
#         media.video_uri != nil ->
#           media.video_uri
#         true ->
#           ""
#         end
#     end
# end
