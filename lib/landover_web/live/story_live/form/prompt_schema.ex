defmodule LandoverWeb.StoryLive.Form.PromptSchema do
  use Ecto.Schema

  embedded_schema do
    field :text, :string
    field :_persistent_id, :integer
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> Ecto.Changeset.cast(attrs, [:text, :_persistent_id])
    |> Ecto.Changeset.validate_required([:text])
  end

  def new(attrs \\ %{}), do: changeset(%LandoverWeb.StoryLive.Form.PromptSchema{}, attrs)
end
