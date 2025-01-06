defmodule Landover.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> handle_tags(attrs)
  end

  defp handle_tags(changeset, %{"tag_ids" => tags}) when is_list(tags) do
    valid_tags =
      tags
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&String.to_integer/1)

    if valid_tags == [] do
      add_error(changeset, :tags, "must include at least one tag")
    else
      story_tags =
        Enum.map(valid_tags, fn tag_id ->
          %Landover.Taggable.StoryTag{tag_id: tag_id}
        end)

      put_assoc(changeset, :story_tags, story_tags)
    end
  end

  defp handle_tags(changeset, _) do
    add_error(changeset, :tags, "must include at least one tag")
  end
end
