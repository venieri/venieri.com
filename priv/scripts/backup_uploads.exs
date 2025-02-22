alias Venieri.Archives.Media

Media.list()
|> Enum.map(fn media ->
  Media.save_to_s3(media)
end)
|> Enum.map(&IO.inspect/1)
|> Enum.count
|> IO.puts
