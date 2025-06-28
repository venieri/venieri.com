alias Venieri.Archives.References

"/Users/thanos/work/v1/venieri.com/priv/repo/data/references.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.take(1)
# |> Enum.filter(fn %{"media" => media} -> media != [] end)
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn reference  ->
  reference
  |> Map.drop(["id", "media"])
  |> References.create()
end)
