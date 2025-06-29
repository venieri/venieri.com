

#
alias Venieri.Repo
alias Venieri.Archives.Works
alias Venieri.Archives.Models.Media
alias Venieri.Archives.Models.Project
alias Venieri.Archives.Models.WorkMedia
require Logger



"/Users/thanos/work/v1/venieri.com/priv/repo/data/artworks.json"
|> File.read!()
|> Jason.decode!()
# |> Enum.take(1)
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn artwork ->
  project = Repo.get_by(Project, title: artwork["project"])
  media =
    artwork["media"]
    |> Enum.map(fn media_ref ->
      Repo.get_by(Media, old_id: media_ref["id"])
    end)
    |> Enum.filter(& &1)

  poster = List.first(media)
  {:ok, art_work} =
  %{
    description: artwork["description"],
    medium: artwork["medium"],
    project_id: (if project != nil, do: project.id, else: nil),
    sd_category: artwork["sd_type"],
    size: artwork["size"],
    title: artwork["title"],
    year: artwork["year"],
    poster_id: (if poster != nil, do: poster.id, else: nil)
  }
  |> Works.create
  media
  |> Enum.map(fn work ->
      changeset = WorkMedia.changeset(%WorkMedia{}, %{
        work_id: art_work.id,
        media_id: work.id
        })
        Repo.insert!(changeset)
  end)
|> IO.inspect()
end)
|> Enum.count()
|> IO.inspect()
# |> Enum.reject(& &1["image"] == nil)
