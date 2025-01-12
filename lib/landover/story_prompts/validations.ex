defmodule Landover.StoryPrompts.Validations do
  import Ecto.Changeset

  def validate_tags(changeset, %{"tag_ids" => tags}) when is_list(tags) do
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

  def validate_tags(changeset, _) do
    add_error(changeset, :tags, "must include at least one tag")
  end

  def validate_tags(changeset) do
    tag_ids = get_field(changeset, :tag_ids, [])

    if Enum.empty?(tag_ids) do
      add_error(changeset, :tag_ids, "must include at least one tag")
    else
      changeset
    end
  end

  def validate_prompts(changeset, %{"prompt_fields" => prompts}) when is_list(prompts) do
    prompts =
      Enum.map(prompts, &Map.from_struct(&1))
      |> Enum.map(&%{text: &1.text, order: &1._persistent_id})
      |> Enum.map(&Landover.StoryPrompts.StoryPrompt.new(&1))

    put_assoc(changeset, :prompts, prompts)
  end

  def validate_prompts(changeset, %{"prompts" => prompts})
      when is_list(prompts) and length(prompts) > 0 do
    put_assoc(changeset, :prompts, prompts)
  end

  def validate_prompts(changeset, _) do
    add_error(changeset, :prompts, "must include at least one prompt")
  end

  def validate_prompts(changeset) do
    prompts = get_field(changeset, :prompts, [])

    if Enum.empty?(prompts) do
      add_error(changeset, :prompts, "You gotta start somewhere!")
    else
      changeset
    end
  end

  def validate_at_least_one_prompt_field(changeset) do
    case Ecto.Changeset.get_field(changeset, :prompt_fields) do
      prompt_fields when is_list(prompt_fields) and length(prompt_fields) > 0 ->
        changeset

      _ ->
        Ecto.Changeset.add_error(changeset, :prompt_fields, "must include at least one prompt")
    end
  end
end
