defmodule Venieri.Archives.Media do
  @moduledoc """
  The Archives context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias Venieri.Repo

  alias Venieri.Archives.Models.Media, as: MediaModel

  alias Venieri.Archives.ImageProcessor

  @a4_size "2480x3508"
  @poster_size "800x800"
  @thumbnail_size "150x150"

  @doc """
  Returns the list of media.

  ## Examples

      iex> list()
      [%Media{}, ...]

  """
  def list do
    Repo.all(MediaModel)
    # |>     dbg(label: "list")
  end

  @doc """
  Gets a single media.

  Raises `Ecto.NoResultsError` if the Media does not exist.

  ## Examples

      iex> get!(123)
      %Media{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(MediaModel, id)

  def get_by(condition), do: Repo.get_by(MediaModel, condition)

  @doc """
  Creates a media.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Media{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(attrs \\ %{}) do
    %MediaModel{}
    |> MediaModel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a media.

  ## Examples

      iex> update(media, %{field: new_value})
      {:ok, %Media{}}

      iex> update(media, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%MediaModel{} = media, attrs) do
    media
    |> MediaModel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a media.

  ## Examples

      iex> delete(media)
      {:ok, %Media{}}

      iex> delete(media)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%MediaModel{} = media) do
    Repo.delete(media)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking media changes.

  ## Examples

      iex> change(media)
      %Ecto.Changeset{data: %Media{}}

  """
  def change(%MediaModel{} = media, attrs \\ %{}) do
    MediaModel.changeset(media, attrs)
  end

  def process_upload(%MediaModel{} = media, temp_file) do
    file_name = media.uploaded_file
    dest = Path.join([full_upload_dir(), file_name])
    File.cp!(temp_file, dest)
    Logger.info("File.cp!(#{temp_file}, #{dest})")

    %{
      "image_width" => image_width,
      "image_height" => image_height,
      "mime_type" => mime_type
    } = meta_data = media_info!(dest)

    media
    |> __MODULE__.update(%{
      meta_data: meta_data,
      type: extract_type(mime_type),
      width: String.to_integer(image_width),
      height: String.to_integer(image_height)
    })
    |> case do
      {:ok, media} ->
        media
        |> tap(&defer("upload_s3", &1))
        |> tap(&gen_thumbnail(&1, 150))
        |> tap(&if_image("gen_press_quality", &1))
        |> tap(&if_image("gen_web_images", &1))

      {:error, changeset} ->
        Logger.error("Error updating media metadata: #{inspect(changeset)}")
    end
  end

  def if_image(action, %MediaModel{} = item) do
    with "image" <> _ <- item.meta_data["mime_type"] do
      defer(action, item)
    end
  end

  def defer(action, %MediaModel{} = item) do
    ImageProcessor.new(%{
      "action" => action,
      "media_id" => item.id
    })
    |> Oban.insert()
  end

  def gen_press_quality(%MediaModel{} = item) do
    with "image" <> _ <- item.meta_data["mime_type"] do
      uploaded_file = Path.join([full_upload_dir(), item.uploaded_file])
      thumbnail_file = Path.join([get_media_path(), item.slug, "#{item.slug}-A4.webp"])

      Mogrify.open(uploaded_file)
      |> mogrify_press_quality()
      |> Mogrify.save(path: thumbnail_file)
    end

    item
  end

  def mogrify_press_quality(file) do
    file
    |> Mogrify.custom("-define", "webp:lossless=true")
    |> Mogrify.resize_to_limit(@a4_size)
    |> Mogrify.custom("-define", "webp:method=1")
    |> Mogrify.custom("quality", "100")
  end

  def gen_thumbnail(%MediaModel{} = item, width) do
    gen_thumbnail(item.meta_data["mime_type"], item, width)
  end

  def gen_thumbnail("image" <> _, item, width) do
    uploaded_file = Path.join([full_upload_dir(), item.uploaded_file])
    thumbnail_file = Path.join([get_media_path(), item.slug, "#{item.slug}-#{width}.webp"])

    Mogrify.open(uploaded_file)
    |> mogrify_thumbnail(width)
    |> Mogrify.save(path: thumbnail_file)

    thumbnail_file = Path.join([get_media_path(), item.slug, "#{item.slug}-#{width}.avif"])

    Mogrify.open(uploaded_file)
    |> Mogrify.resize_to_limit("#{width}x#{width}")
    |> Mogrify.custom("-define", "avif:quality=70")
    |> Mogrify.save(path: thumbnail_file)

    item
  end

  def mogrify_thumbnail(file, width) do
    file
    |> Mogrify.custom("-define", "webp:lossless=false")
    |> Mogrify.resize_to_limit("#{width}x#{width}")
    |> Mogrify.custom("-define", "webp:method=1")
    |> Mogrify.custom("quality", "70")
  end

  """
  For Ubuntu/Debian: sudo apt-get install ffmpeg imagemagick
  For MacOS: brew install ffmpeg imagemagick
  """

  def gen_thumbnail("video" <> _, item, _width) do
    uploaded_file = Path.join([full_upload_dir(), item.uploaded_file])
    thumbnail_file = Path.join([get_media_path(), "#{item.slug}.webp"])
    # First use ffmpeg to extract the frame at 3 seconds
    System.cmd("ffmpeg", [
      # Input video file
      "-i",
      uploaded_file,
      # Seek to 3 seconds
      "-ss",
      "00:00:03",
      # Extract only one frame
      "-frames:v",
      "1",
      # Force image2 format
      "-f",
      "image2",
      # Output path for the image
      thumbnail_file
    ])

    item
  end

  def process_upload(_item, entry, %{path: _path} = meta) do
    params =
      prepare_upload(entry, meta)
      |> Map.put(:uploaded_file, file_name(entry))

    {:ok, media} =
      __MODULE__.create(params)

    {:ok, file_url(media.uploaded_file)}
    media
  end

  def process(%MediaModel{} = item) do
    ImageProcessor.new(%{
      "action" => "process",
      "media_id" => item.id
    })
    |> Oban.insert()
  end

  def normalize(%MediaModel{} = item) do
    normalize(get_upload_file(item), get_media_path())
  end

  def normalize(uploaded_image, dest_path) do
    normalized_image =
      Path.join([dest_path, Path.rootname(Path.basename(uploaded_image)) <> ".webp"])

    Mogrify.open(uploaded_image)
    |> Mogrify.format("webp")
    |> Mogrify.custom("-define", "webp:lossless=true")
    |> Mogrify.custom("-define", "webp:method=6")
    # Set highest quality
    |> Mogrify.custom("quality", "100")
    |> Mogrify.custom("strip")
    |> Mogrify.save(path: normalized_image)
    |> Mogrify.verbose()

    normalized_image
  end

  def prepare_upload(entry, %{path: path} = _meta), do: prepare_upload(entry, path)

  def prepare_upload(entry, path) do
    file_name = file_name(entry)
    dest = Path.join([:code.priv_dir(:venieri), "static", upload_dir(), file_name])
    File.mkdir_p!(Path.dirname(dest))
    File.cp!(path, dest)
    Logger.info("File.cp!(#{path}, #{dest})")

    %{
      "image_width" => image_width,
      "image_height" => image_height,
      "file_type" => file_type,
      "mime_type" => _mime_type
    } = meta_data = media_info!(dest)

    %{
      meta_data: meta_data,
      type: file_type,
      width: String.to_integer(image_width),
      height: String.to_integer(image_height)
    }
  end

  defp file_url(file_name) do
    static_path = Path.join([upload_dir(), file_name])
    Phoenix.VerifiedRoutes.static_url(VenieriWeb.Endpoint, "/" <> static_path)
  end

  defp file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    entry.uuid <> "." <> ext
  end

  def get_upload_file_path(uploaded_file) do
    root = :code.priv_dir(:venieri)

    Path.join([
      root,
      Application.fetch_env!(:venieri, :uploads)[:upload_path],
      uploaded_file
    ])
  end

  def upload_dir, do: Application.fetch_env!(:venieri, :uploads)[:upload_path]

  def full_upload_dir do
    root = :code.priv_dir(:venieri)
    Path.join([root, Application.fetch_env!(:venieri, :uploads)[:upload_path]])
  end

  def full_media_dir do
    root = :code.priv_dir(:venieri)
    Path.join([root, Application.fetch_env!(:venieri, :uploads)[:media_path]])
  end

  def get_upload_file_path(%MediaModel{} = media) do
    get_upload_file_path(media.uploaded_file)
  end

  def get_upload_file_path(uploaded_file) do
    root = :code.priv_dir(:venieri)

    Path.join([
      root,
      Application.fetch_env!(:venieri, :uploads)[:upload_path],
      uploaded_file
    ])
  end

  def get_upload_file(%MediaModel{} = media) do
    get_upload_file(media.uploaded_file)
  end

  def get_upload_file(uploaded_file) do
    root = :code.priv_dir(:venieri)

    Path.join([
      root,
      Application.fetch_env!(:venieri, :uploads)[:upload_path],
      uploaded_file
    ])
  end

  def get_media_file(%MediaModel{} = media, ext \\ "avif") do
    get_media_file(media.slug, ext)
  end

  def get_media_file(slug, ext) do
    root = :code.priv_dir(:venieri)
    media_path = Path.join([root, Application.fetch_env!(:venieri, :uploads)[:media_path]])
    if File.exists?(media_path) != true, do: File.mkdir_p(media_path)
    Path.join([media_path, "#{slug}.#{ext}"])
  end

  def get_media_path() do
    root = :code.priv_dir(:venieri)
    media_path = Path.join([root, Application.fetch_env!(:venieri, :uploads)[:media_path]])
  end

  def url2(%MediaModel{} = media) do
    url(media, nil)
  end

  def url2(%MediaModel{} = media, width) do
    with_postfix =
      if width == nil do
        ""
      else
        "-#{width}"
      end

    cond do
      media.meta_data != nil ->
        small_image = "#{media.slug}#{with_postfix}.avif"

        Phoenix.VerifiedRoutes.static_url(
          VenieriWeb.Endpoint,
          "/" <> Path.join(["media", small_image])
        )

      media.uploaded_file != nil ->
        Phoenix.VerifiedRoutes.static_url(
          VenieriWeb.Endpoint,
          "/" <>
            Path.join([
              Application.fetch_env!(:venieri, :uploads)[:upload_path],
              media.uploaded_file
            ])
        )

      media.external_uri != nil ->
        media.external_uri

      true ->
        ""
    end
  end

  def is_vertical?(%MediaModel{} = media) do
    media.width < media.height
  end

  def url(%MediaModel{} = media, opts \\ []) do
    width = Keyword.get(opts, :width, 1024)
    type = Keyword.get(opts, :type, "webp")

    case media.type do
      "image" ->
        with_postfix =
          if width == nil do
            ""
          else
            "-#{width}"
          end

        Path.join(["/", "media", media.slug, "#{media.slug}#{with_postfix}.#{type}"])
    end
  end

  def select_media(query, _assigns) do
    query
    # |> where([media], is_nil(media.uploaded_file) == true)
    |> select_merge([media], %{
      icon: fragment("concat('/media/', ?, '/',?,?)", media.slug, media.slug, "-150.webp")
    })
  end

  def src_for(%MediaModel{} = media, width \\ nil) do
    if media.type == "image" do
      with_postfix =
        if width == nil do
          ""
        else
          "-#{width}"
        end

      if media.meta_data != nil do
        small_image = "#{media.slug}#{with_postfix}.avif"

        Phoenix.VerifiedRoutes.static_url(
          VenieriWeb.Endpoint,
          "/" <> Path.join(["media", small_image])
        )
      else
        Phoenix.VerifiedRoutes.static_url(
          VenieriWeb.Endpoint,
          "/" <>
            Path.join([
              Application.fetch_env!(:venieri, :uploads)[:upload_path],
              media.uploaded_file
            ])
        )
      end
    else
      media.external_uri
    end
  end

  def media_info!(%Mogrify.Image{path: image_path}), do: media_info!(image_path)

  def media_info!(path) do
    {:ok, metadata} = Exiftool.execute([path])

    metadata
    |> dbg()
  end

  def extract_type("image" <> _), do: "image"
  def extract_type("video" <> _), do: "video"
  def extract_type("audio" <> _), do: "audio"
  def extract_type("text" <> _), do: "document"
end
