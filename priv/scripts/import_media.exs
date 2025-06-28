alias Venieri.Archives.Media
require Logger



"/Users/thanos/work/v1/venieri.com/priv/repo/data/media.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.take(1)
|> Enum.reject(& &1["image"] == nil)
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn media ->
  %{
    "caption" => caption,
    "id" => old_id,
    "image" => image,
    "video_url" => video_url
  } = media

   {:ok, media} = Media.create(%{
      caption: caption,
      uploaded_file: Path.basename(image),
      old_id: old_id
   })
   Venieri.Archives.Media.process_upload(media, image)
end)
