defmodule ImageProcessor do
  @moduledoc """
  A module to handle image processing tasks like removing EXIF data.
  """
   use Oban.Worker
   require Logger


  def convert(media_path) do
    ImageProcessor.new(%{"action" => "convert", "media_path"=> media_path}) |> Oban.insert()
  end

   def make_normalize_job(src, dst) do
    ImageProcessor.new(%{"action" => "normalize", "src"=> src, "dst"=> dst}) |> Oban.insert()
   end

   def make_resize_job(src, width) do
     Logger.debug("make_resize_job(#{src}, #{width})")
     ImageProcessor.new(%{"action" => "resize", "src"=> src,  "width"=> width})
     |> Oban.insert()
   end

   @impl Oban.Worker
    def perform(%Oban.Job{args: %{"action" => "resize"} = args}) do
      %{"src"=> src, "width"=> width} = args
      ImageHelpers.resize(src, width)
      :ok
    end


    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"action" => "process"} = args}) do
      %{"media_id" => media_id} = args
      media = Venieri.Archives.Media.get!(media_id)
      image_path = Venieri.Archives.Media.normalize(media)
      [480, 640, 768, 1024, 1280, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
      |> Enum.each(& make_resize_job(image_path, &1))
      :ok
    end

   @impl Oban.Worker
    def perform(%Oban.Job{args: %{"action" => "normalize"} = args}) do
      %{"src" => src, "dst"=> dst} = args
      %Mogrify.Image{path: path} = ImageHelpers.normalize(src, dst)
        [640, 768, 1024, 1280, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
        |> Enum.each(& make_resize_job(dst, &1))
      :ok
    end

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"action" => "convert"} = args}) do
      %{"media_path" => media_path} = args
      [480, 640, 768, 1024, 1280, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
      |> Enum.each(fn width ->
        {:ok, thumbnail} =  Image.thumbnail(media_path, width)
        {:ok, ^thumbnail} = Image.write(thumbnail, "#{Path.rootname(media_path)}-#{width}.avif")
      end)
      :ok
    end


  require Logger

#   def thumbnail(image_path,  dest_path, width) do
#     if File.exists?(image_path) do
#       # thumbnail_dir = Path.basename(Path.rootname(dest_path))
#       # thumbnail_file = Path.join(thumbnail_dir, Path.basename(image_path))
#       dest_dir = Path.dirname(dest_path)
#       try do
#         if File.exists?(dest_dir) == true, do: :ok = File.mkdir_p(dest_dir)
#           {:ok, thumbnail} =  Image.thumbnail(image_path, width)
#           {:ok, thumbnail} = Image.write(thumbnail, dest_path)
#         rescue
#           e -> Logger.error("Error while resizing the image: #{inspect(e)}")
#       end
#     else
#       {:error, "File not found"}
#     end
#   end

#   def remove_exif(image_path, output_path) do
#     if File.exists?(image_path) do
#         try do
#           Exiftool.execute(["-all=", image_path,  "-o",  output_path])
#           {:ok, "EXIF data removed successfully, saved to #{output_path}"}
#         rescue
#           e ->
#             Logger.error("Error while removing exif from the image: #{inspect(e)}")
#             {:error, "Failed to process the image"}
#         end
#     else
#       {:error, "File not found"}
#     end
#   end


end
