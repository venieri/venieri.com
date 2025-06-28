
alias Venieri.Repo
alias Venieri.Archives.Posts
alias Venieri.Archives.Models.Media
alias Venieri.Archives.Models.PostMedia
alias Venieri.Archives.Models.Tag
alias Venieri.Archives.Tags
alias Venieri.Archives.Models.PostTag

# require Logger
#
#
process_media = fn
  post, nil -> []
  post, media_list ->
  media_list
  |> Enum.map(fn media ->
    media = Repo.get_by(Media, old_id: media)
    if media != nil do
      changeset = PostMedia.changeset(%PostMedia{}, %{
        post_id: post.id,
        media_id: media.id
      })
      Repo.insert!(changeset)
    end
  end)
end

process_tags = fn
  post, nil -> []
  post, tag_list ->
    tag_list
    |> Enum.map(fn tag_label ->
      tag =
        Repo.get_by(Tag, label: tag_label)
      |> case do
        nil ->
          {:ok, tag} = Tags.create(%{label: tag_label})
          tag
        tag -> tag
      end
      changeset = PostTag.changeset(%PostTag{}, %{
        post_id: post.id,
        tag_id: tag.id
        })
      Repo.insert!(changeset)
    end)
end


"/Users/thanos/work/v1/venieri.com/priv/repo/data/events.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.filter(& is_list(&1["media_array"]) && length(&1["media_array"]) > 0)
# |> Enum.take(1)
|>Enum.map(&IO.inspect/1)
|> Enum.map(fn %{
  "end_date" => end_date,
  "caption" => caption,
  "description" =>description,
  "is_visible" => is_visible,
  "leader" => leader,
  "media_array" => media_array,
  "published" => published,
  "slug" => slug,
  "start_date" => start_date,
  "tag_array" => tag_array,
  "title" => title,
  "venue" => venue
} ->
%{
  title: title,
  logline: leader,
  description: description,
  post_date: (start_date |> Timex.parse!("{RFC3339}")),
  to_show: is_visible,
  orientation: "auto",
  venue: venue,
  start_date: start_date,
  end_date: end_date
}
|> IO.inspect()
|> Posts.create
|> case do
  {:ok, post} ->
    process_media.(post, media_array)
    process_tags.(post, tag_array)
    end
  {:error, changeset} ->
    {:error, changeset}
end)
|> Enum.map(&IO.inspect/1)
