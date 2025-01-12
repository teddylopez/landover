defmodule Landover.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

  import Landover.StoryPrompts.Validations

  schema "stories" do
    field :title, :string
    field :metadata, :map, default: %{}
    field :completed_at, :naive_datetime
    field :private, :boolean, default: true

    has_many :story_tags, Landover.Taggable.StoryTag, on_replace: :delete
    has_many :tags, through: [:story_tags, :tag]
    has_many :prompts, Landover.StoryPrompts.StoryPrompt, on_replace: :delete

    belongs_to(:author, Landover.Accounts.User, foreign_key: :author_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:title, :author_id, :completed_at, :metadata, :private])
    |> validate_required([:title, :author_id])
    |> validate_tags(attrs)
    |> validate_prompts(attrs)
  end
end
