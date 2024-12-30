defmodule Landover.Taggable.Tagging do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taggings" do
    belongs_to :tag, Landover.Taggable.Tag
    belongs_to :story, Landover.Stories.Story

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(tagging, attrs) do
    tagging
    |> cast(attrs, [])
    |> unique_constraint(:name, name: :taggings_tag_id_story_id_index)
    |> cast_assoc(:tag)
  end
end
