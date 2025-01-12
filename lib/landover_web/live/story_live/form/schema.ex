defmodule LandoverWeb.StoryLive.Form.Schema do
  use Ecto.Schema

  import Landover.StoryPrompts.Validations

  alias LandoverWeb.StoryLive.Form.PromptSchema
  alias LandoverWeb.StoryLive.Form.Schema

  embedded_schema do
    field :title, :string
    field :tag_ids, {:array, :string}, default: []
    field :private, :boolean, default: true

    embeds_many :prompt_fields, PromptSchema, on_replace: :delete
  end

  def new(story) do
    %Schema{
      title: story.title,
      tag_ids: story_tag_ids(story),
      private: story.private,
      prompt_fields: build_prompt_fields(story.prompts)
    }
    |> changeset()
  end

  defp build_prompt_fields(prompts) do
    prompts
    |> Enum.map(&Map.from_struct/1)
    |> Enum.map(&PromptSchema.new/1)
  end

  def changeset(schema, attrs \\ %{}) do
    schema
    |> Ecto.Changeset.cast(attrs, [:title, :tag_ids, :private])
    |> Ecto.Changeset.validate_required([:title])
    |> Ecto.Changeset.cast_embed(:prompt_fields,
      with: &PromptSchema.changeset/2,
      sort_param: :prompt_fields_order,
      drop_param: :prompt_fields_drop
    )
    |> validate_tags()
    |> validate_at_least_one_prompt_field()
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
      "tag_ids" => set_tags(data),
      "private" => data.private,
      "prompts" => data.prompt_fields
    }

    {:ok, output}
  end

  defp format_result(error), do: error

  defp set_tags(data) do
    if Map.has_key?(data, :tag_ids) do
      data.tag_ids
    else
      Enum.map(data.tag_ids, & &1.tag_id)
    end
  end

  defp story_tag_ids(story), do: Enum.map(story.story_tags, &"#{&1.tag_id}")
end
