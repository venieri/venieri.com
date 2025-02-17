alias Venieri.Archives.Media
require Logger



"priv/repo/data/media.json"
|> File.read!()
|> Jason.decode!()
|> Enum.reject(& &1["image"] == nil)
# |> Enum.take(1)
|> Enum.map(fn media ->
  %{
    "caption" => caption,
    "id" => id,
    "image" => image,
    "video_url" => video_url
  } = media

  %{
    "image_width" => image_width,
    "image_height" => image_height,
    "file_type" => file_type,
    "mime_type" => _mime_type,
  } = meta_data = ImageHelpers.info!(image)


  {:ok, media} = Media.create(%{
    caption: caption,
    old_id: id,
    original_file: image,
    video_url: video_url,
    meta_data: meta_data,
    type: file_type,
    width: String.to_integer(image_width),
    height: String.to_integer(image_height)
  })
  media
end)
|> Enum.map(fn media ->
  file_to_store = get_upload_file_path.(media.original_file, media.slug)
  File.cp!(media.original_file, file_to_store)
  Media.update(media, %{original_file: Path.basename(file_to_store)})
  media_file = get_media_file_path.(media.slug)
  ImageProcessor.make_normalize_job(file_to_store, media_file)
  Logger.info("ImageProcessor.make_normalize_job(#{file_to_store}, #{media_file}")



    # root = :code.priv_dir(:venieri)
    # upload_path = Path.join([root, Application.fetch_env!(:venieri, :uploads)[:upload_path]])
    # media_path = Path.join([root, "static", Application.fetch_env!(:venieri, :uploads)[:media_path]])
    # if File.exists?(upload_path) != true, do: File.mkdir_p(upload_path)
    # if File.exists?(media_path) != true, do: File.mkdir_p(media_path)
    # file_name = Path.basename(media.original_file)
    # original_upload = Path.join([upload_path, file_name])

    # # File.cp!(media.original_file, original_upload)
    # media_file = Path.join([media_path, "#{media.slug}.webp"])
    # Logger.info("ImageProcessor.make_normalize_job(#{original_upload}, #{media_file}")

#     Logger.info("processing #{original_upload} ")
#     ImageProcessor.make_normalize_job(original_upload, media_file)
#     Media.update(media, %{original_file: media_file})
end)
