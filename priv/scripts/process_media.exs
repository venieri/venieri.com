alias Venieri.Archives.Media
require Logger
Media.list()
|> Enum.take(1)
|> Enum.map(fn media ->
  # image =
  #   Media.normalize(media)
  # if File.exists?(image) do
  #  Logger.info("File exists")
  # else
  #   Logger.error("File does not exist")
  # end
  # image
  Media.process(media)
end)
# |> Enum.filter(fn media ->
#   media.slug
#   |> Media.get_media_file_path()
#   |> File.exists?() == false
# end)
# |> Enum.take(1)
# |> Enum.map(fn media ->
#   file = Media.get_upload_file_path(media.original_file)
#   %{
#     "image_width" => image_width,
#     "image_height" => image_height,
#     "file_type" => file_type,
#     "mime_type" => _mime_type,
#   } = meta_data = ImageHelpers.info!(file)
#   {:ok, media} = Media.update(media, %{
#     meta_data: meta_data,
#     type: file_type,
#     width: String.to_integer(image_width),
#     height: String.to_integer(image_height),
#   })
#   media
# end)
# |> Enum.map(fn media ->
#   uploaded_file = Media.get_upload_file_path(media.original_file)
#   media_file = Media.get_media_file_path(media.slug)
#   ImageProcessor.make_normalize_job(uploaded_file, media_file)
#   Logger.info("ImageProcessor.make_normalize_job(#{uploaded_file}, #{media_file}")
# end)
|> Enum.map(&IO.inspect/1)
|> Enum.count
|> IO.inspect()



# |> Enum.each(fn media ->
#   file = Media.get_upload_file_path(media.original_file, media.slug)
#   %{
#     "image_width" => image_width,
#     "image_height" => image_height,
#     "file_type" => file_type,
#     "mime_type" => _mime_type,
#   } = meta_data = ImageHelpers.info!(file)
#   Media.update(media, %{
#     meta_data: meta_data,
#     type: file_type,
#     width: String.to_integer(image_width),
#     height: String.to_integer(image_height)
#   })

  # file_name = Path.basename(original_file)
  # Media.update(media, %{original_file: file_name})

# end)
