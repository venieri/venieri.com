
alias Venieri.Repo
alias Venieri.Archives.Events
alias Venieri.Archives.Models.Media
alias Venieri.Archives.Models.EventMedia
alias Venieri.Archives.Models.Tag
alias Venieri.Archives.Tags
alias Venieri.Archives.Models.EventTag
# require Logger

"priv/repo/data/events.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.take(10)
# |> Enum.filter(fn %{"leader" => leader} -> leader != "" end)
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn event_json ->
  {:ok, event} =
  %{
    description: event_json["description"],
    title: event_json["title"],
    start_date: event_json["start_date"],
    end_date: event_json["end_date"],
    venue: event_json["venue"],
    show: event_json["published"],
    description: event_json["description"]
  }
  |> Events.create
  media_array = event_json["media_array"]
  if is_list(media_array) do
  media_array
  |> Enum.map(fn media_id ->
      media = Repo.get_by(Media, old_id: media_id)
          if media != nil do
            changeset = EventMedia.changeset(%EventMedia{}, %{
              event_id: event.id,
              media_id: media.id
              })
            Repo.insert!(changeset)
          end
    end)
  end
  tag_array = event_json["tag_array"]
  if is_list(tag_array) do
    tag_array
    |> Enum.map(fn tag_label ->
      tag =
        Repo.get_by(Tag, label: tag_label)
        |> case do
          nil ->
            {:ok, tag} = Tags.create(%{label: tag_label})
            tag
          tag -> tag
        end
      EventTag.changeset(%EventTag{}, %{
        event_id: event.id,
        tag_id: tag.id
        })
      |> Repo.insert!
    end)
    end
end)
|> Enum.map(&IO.inspect/1)
# |> IO.inspect()
# end)
|> Enum.count()
|> IO.inspect()
# |> Enum.reject(& &1["image"] == nil)
