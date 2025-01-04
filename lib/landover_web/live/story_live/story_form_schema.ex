defmodule LandoverWeb.StoryLive.StoryFormSchema do
  use Ecto.Schema

  alias LandoverWeb.StoryLive.StoryFormSchema

  embedded_schema do
    field :title, :string
    field :tag_ids, {:array, :string}, default: []
    field :private, :boolean, default: true
  end

  def new(story) do
    schema = %StoryFormSchema{
      title: story.title,
      tag_ids: story_tag_ids(story),
      private: story.private
    }

    changeset(schema)
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> Ecto.Changeset.cast(attrs, [:title, :tag_ids, :private])
    |> Ecto.Changeset.validate_required([:title])
    |> validate_tag_ids()
  end

  def validate(form, params) do
    form.source.data
    |> changeset(params)
    |> Map.put(:action, :validate)
  end

  def submit(form, params) do
    form.source.data
    |> changeset(params)
    |> Ecto.Changeset.apply_action(:insert)
    |> format_result()
  end

  defp format_result({:ok, data}) do
    output = %{
      "title" => data.title,
      "tag_ids" =>
        if(Map.has_key?(data, :tag_ids),
          do: data.tag_ids,
          else: Enum.map(data.tag_ids, & &1.tag_id)
        ),
      "private" => data.private
    }

    {:ok, output}
  end

  defp format_result(error), do: error

  defp story_tag_ids(story), do: Enum.map(story.story_tags, &"#{&1.tag_id}")

  defp validate_tag_ids(changeset) do
    tag_ids = Ecto.Changeset.get_field(changeset, :tag_ids, [])

    if Enum.empty?(tag_ids) do
      Ecto.Changeset.add_error(changeset, :tag_ids, "must include at least one tag")
    else
      changeset
    end
  end
end
