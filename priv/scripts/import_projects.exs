alias Venieri.Archives.Projects

"priv/repo/data/projects.json"
|> File.read!()
|> Jason.decode!()
|> Enum.map(fn project ->
  %{"id" => id, "statement" => statement, "title" => title} = project
  Projects.create(project)
end)
|> Enum.each(& IO.inspect/1)
