
alias Venieri.Repo
alias Venieri.Archives.Events
alias Venieri.Archives.Models.Event

# require Logger

"priv/repo/data/events.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.take(10)
# |> Enum.filter(fn %{"leader" => leader} -> leader != "" end)
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn event_json ->
  event = Repo.get_by(Event,
    title: event_json["title"],
    start_date: event_json["start_date"],
    venue: event_json["venue"])
    if event != nil do
      {:ok, event} =
        event
        |> Events.update(%{leader: event_json["leader"], show: event_json["is_visible"]})
    end
end)
# |> Enum.reject(&is_nil/1)
|> Enum.map(&IO.inspect/1)
|> Enum.count()
|> IO.inspect()
