alias Venieri.Archives.Projects

"/Users/thanos/work/v1/venieri.com/priv/repo/data/projects.json"
|> File.read!()
|> Jason.decode!()
|> Enum.map(fn project ->
  %{"id" => id, "statement" => statement, "title" => title} = project
  Projects.create(project)
end)
|> Enum.each(& IO.inspect/1)
