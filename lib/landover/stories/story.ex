defmodule Landover.Stories.Story do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field :name, :string
    field :metadata, :map, default: %{}
    field :completed_at, :naive_datetime

    has_many :taggings, Landover.Taggable.Tagging
    has_many :tags, through: [:taggings, :tag]

    belongs_to(:author, Landover.Accounts.User, foreign_key: :author_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(story, attrs) do
    story
    |> cast(attrs, [:name, :author_id, :completed_at, :metadata])
    |> validate_required([:name, :author_id])
  end
end
