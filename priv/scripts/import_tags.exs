"/Users/thanos/work/v1/venieri.com/tags.json"
|> File.read!()
|> Jason.decode!()
|> Enum.map(fn %{"label" => label} ->
  Venieri.Archives.Tags.create(%{label: label})
end)
|> Enum.map(&IO.inspect/1)
