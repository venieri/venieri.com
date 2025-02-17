defmodule ImageHelpers do
  @moduledoc """
  A module to handle image processing tasks like removing EXIF data.
  """

  alias Image
  alias Exiftool
  alias Temp

  require Logger

  def info!(%Mogrify.Image{path: image_path}), do: info!(image_path)
  def info!(path) do
    {:ok, metadata} = Exiftool.execute([path])
    metadata
  end

  def normalize(image_path) do
    {:ok, dest_path} = Temp.path
    normalize(image_path, dest_path)
  end

   def normalize(original_image, dest_path) do
    normalized_image = Path.join([dest_path, Path.rootname(Path.basename(original_image))<>".webp"])
      Mogrify.open(original_image)
      |> Mogrify.format("webp")
      |> Mogrify.custom("-define", "webp:lossless=true")
      |> Mogrify.custom("-define", "webp:method=6")
      |> Mogrify.custom("quality", "100")    # Set highest quality
      |> Mogrify.custom("strip")
      |> Mogrify.save(path: normalized_image)
      |> Mogrify.verbose
      normalized_image
  end



  def thumbnail!(%Mogrify.Image{path: image_path}, dest_path, width) do
    thumbnail!(image_path, dest_path, width)

    {:ok, metadata} = Exiftool.execute([image_path])
    %{
      "image_width" => image_width,
      "image_height" => image_height,
      "file_type" => file_type,
      "mime_type" => _mime_type,
    } = metadata
  %{
      path: dest_path,
      format: file_type,
      width: image_width,
      height: image_height
    }
  end


  def resize(src, width, quality \\ 75) when is_integer(width)  do
      resize(src, "#{Path.rootname(src)}-#{width}.avif", width, quality)
  end

  def resize(src, dst, width, _quality ) when is_binary(dst) do
    {:ok, thumbnail} =  Image.thumbnail(src, width)
    {:ok, ^thumbnail} = Image.write(thumbnail, dst)
 end


  def remove_exif!(%{path: image_path} = image) do
    {:ok, _meta_data}  = remove_exif(["--GPS*:all=", image_path])
    image
  end


  def remove_exif(image_path, output_path) do
    remove_exif(["-all=", image_path, "-o",  output_path])
    output_path
  end

  def remove_exif(cmd) do
        try do
          Exiftool.execute(cmd)
        rescue
          e ->
            Logger.error("Error while removing exif from the image: #{inspect(e)}")
            {:error, "Failed to process the image"}
        end
  end
end
