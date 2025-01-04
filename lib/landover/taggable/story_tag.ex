defmodule Landover.Taggable.StoryTag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "story_tags" do
    belongs_to :tag, Landover.Taggable.Tag
    belongs_to :story, Landover.Stories.Story

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [])
    |> unique_constraint(:name, name: :story_tags_tag_id_story_id_index)
    |> cast_assoc(:tag)
    |> cast_tags(attrs["story_tags"])
  end

  defp cast_tags(changeset, nil), do: changeset

  defp cast_tags(changeset, tag_ids) when is_list(tag_ids) do
    story_tags =
      tag_ids
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(&%{tag_id: String.to_integer(&1)})

    put_assoc(changeset, :story_tags, story_tags)
  end
end
