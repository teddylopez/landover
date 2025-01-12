defmodule Landover.StoryPrompts.StoryPrompt do
  use Ecto.Schema
  import Ecto.Changeset

  alias Landover.StoryPrompts.StoryPrompt

  schema "story_prompts" do
    field :text, :string
    field :order, :integer

    belongs_to :story, Landover.Stories.Story

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(story_prompt, attrs) do
    story_prompt
    |> cast(attrs, [:order, :text])
    |> validate_required([:order, :text])
  end

  def new(attrs \\ %{}) do
    changeset(%StoryPrompt{}, attrs)
  end
end
