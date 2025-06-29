defmodule Venieri.Archives.Models.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Venieri.Archives.Models.Tag
  alias Venieri.Archives.Models.Work
  alias Venieri.Archives.Models.ProjectTag
  alias Venieri.Archives.Models.TitleSlug
  alias Venieri.Archives.Models.Media
  alias Venieri.Archives.Models.ProjectMedia

  schema "projects" do
    field :description, :string
    field :title, :string
    field :slug, TitleSlug.Type
    field :statement, :string
    field :show, :boolean, default: true

    many_to_many :tags, Tag, join_through: ProjectTag, on_replace: :delete
    many_to_many :media, Media, join_through: ProjectMedia, on_replace: :delete
    has_many(:works, Work, on_replace: :nilify)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs, _meta \\ []) do
    project
    |> cast(attrs, [:title, :slug, :description, :statement, :show])
    |> validate_required([:title, :show])
    |> unique_constraint(:title)
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
  end
end
