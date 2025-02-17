

#
alias Venieri.Repo
alias Venieri.Archives.Works
alias Venieri.Archives.Models.Media
alias Venieri.Archives.Models.Project
alias Venieri.Archives.Models.WorkMedia
require Logger



"priv/repo/data/artworks.json"
|> File.read!()
|> Jason.decode!()
|> Enum.map(&IO.inspect/1)
|> Enum.map(fn artwork ->
  project = Repo.get_by(Project, title: artwork["project"])
  {:ok, art_work} = %{
    description: artwork["description"],
    material: artwork["medium"],
    project_id: (if project != nil, do: project.id, else: nil),
    sd_type: artwork["sd_type"],
    size: artwork["size"],
    title: artwork["title"],
    year: artwork["year"],
  }
  |> Works.create
  artwork["media"]
  |> Enum.map(fn media_ref ->
    media = Repo.get_by(Media, old_id: media_ref["id"])
    if media != nil do
      changeset = WorkMedia.changeset(%WorkMedia{}, %{
        work_id: art_work.id,
        media_id: media.id
        })
      Repo.insert!(changeset)
    end
  end)

|> IO.inspect()
end)
|> Enum.count()
|> IO.inspect()
# |> Enum.reject(& &1["image"] == nil)
