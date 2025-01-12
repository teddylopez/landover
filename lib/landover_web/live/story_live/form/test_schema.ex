defmodule LandoverWeb.StoryLive.Form.TestSchema do
  use Ecto.Schema

  embedded_schema do
    field :text, :string
    field :_persistent_id, :integer
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> Ecto.Changeset.cast(attrs, [:text, :_persistent_id])
  end

  def new(attrs \\ %{}), do: changeset(%LandoverWeb.StoryLive.Form.TestSchema{}, attrs)
end
