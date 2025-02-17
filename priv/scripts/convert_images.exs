alias Venieri.Archives.Media
alias Image

Media.list()
# |> Enum.take(1)
# |>Enum.map(fn media ->
#   original_file = media.original_file

#   original_path =  Media.get_upload_file_path(original_file)
#   media_path  = Media.get_media_file_path(media.slug)
#   [480, 640, 768, 1024, 1280, 1536, 1920, 2560, 3840, 4096, 5120, 7680]
#   |> Enum.each(fn width ->

#     {:ok, thumbnail} =  Image.thumbnail(media_path, width)
#     {:ok, ^thumbnail} = Image.write(thumbnail, "#{Path.rootname(media_path)}-#{width}.avif")

#   end)
# end)
|>Enum.map(fn media ->
  media_path  = Media.get_media_file_path(media.slug)
  ImageProcessor.convert(media_path)
end)
|> Enum.map(&IO.inspect/1)
