defmodule Landover.Taggable.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  @genre_options [
    {"Adventure", "adventure"},
    {"Alien Invasion", "alien-invasion"},
    {"Alternate History", "alternate-history"},
    {"Art & Photography", "art-photography"},
    {"Biography", "biography"},
    {"Children's Fiction", "children-fiction"},
    {"Comics & Graphic Novels", "comics-graphic-novels"},
    {"Cooking", "cooking"},
    {"Crafts & Hobbies", "crafts-hobbies"},
    {"Cyberpunk", "cyberpunk"},
    {"Detective & Mystery", "mystery"},
    {"Dystopian", "dystopian"},
    {"Dystopian Thriller", "dystopian-thriller"},
    {"Epic Fantasy", "epic-fantasy"},
    {"Essays", "essays"},
    {"Fantasy", "fantasy"},
    {"Fantasy & Science Fiction", "fantasy-sci-fi"},
    {"Grimdark", "grimdark"},
    {"Hard Science Fiction", "hard-sci-fi"},
    {"Health & Fitness", "health-fitness"},
    {"Historical Fantasy", "historical-fantasy"},
    {"Historical Fiction", "historical-fiction"},
    {"History", "history"},
    {"Horror", "horror"},
    {"Humor", "humor"},
    {"LitRPG", "litrpg"},
    {"Manga", "manga"},
    {"Memoir & Autobiography", "autobiography"},
    {"Military Science Fiction", "military-sci-fi"},
    {"Nature", "nature"},
    {"Parenting & Family", "parenting-family"},
    {"Paranormal Romance", "paranormal-romance"},
    {"Philosophy", "philosophy"},
    {"Plays", "plays"},
    {"Poetry", "poetry"},
    {"Post-Apocalyptic", "post-apocalyptic"},
    {"Religion & Spirituality", "religion-spirituality"},
    {"Romance", "romance"},
    {"Romantic Fantasy", "romantic-fantasy"},
    {"Science", "science"},
    {"Science Fiction", "sci-fi"},
    {"Self-Help", "self-help"},
    {"Short Stories", "short-stories"},
    {"Soft Science Fiction", "soft-sci-fi"},
    {"Space Colonization", "space-colonization"},
    {"Space Exploration", "space-exploration"},
    {"Space Fleet", "space-fleet"},
    {"Space Marines", "space-marines"},
    {"Space Opera", "space-opera"},
    {"Space Pirates", "space-pirates"},
    {"Space Western", "space-western"},
    {"Steampunk", "steampunk"},
    {"Superhero", "superhero"},
    {"Sword & Sorcery", "sword-sorcery"},
    {"Thriller", "thriller"},
    {"Time Travel", "time-travel"},
    {"Travel", "travel"},
    {"Urban Fantasy", "urban-fantasy"},
    {"Young Adult (YA)", "young-adult"}
  ]

  @valid_genres Enum.map(@genre_options, fn {_name, slug} -> slug end)

  schema "tags" do
    field :name, :string
    field :slug, :string

    has_many :story_tags, Landover.Taggable.StoryTag
    has_many :stories, through: [:story_tags, :story]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name, :slug])
    |> validate_subset(:name, @valid_genres)
  end

  def valid_genres do
    @valid_genres
  end

  def genre_options do
    @genre_options
  end
end
