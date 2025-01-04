defmodule Landover.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false
  alias Landover.Repo

  alias Landover.Taggable.Tag
  alias Landover.Taggable.StoryTag

  def list_tags do
    Repo.all(Tag)
  end

  def list_tags(params = %{}) do
    build_query(params)
  end

  defp base_query do
    from(tag in Tag,
      as: :tag
    )
  end

  defp build_query(params) do
    base_query()
    |> filter_by_id(params[:id])
    |> filter_by_query(params[:query])
    |> sort_by(params[:sort_by])
  end

  defp filter_by_id(query, nil), do: query

  defp filter_by_id(query, ids) when is_list(ids) do
    from([tag: tag] in query,
      where: tag.id in ^ids
    )
  end

  defp filter_by_id(query, id) when is_binary(id), do: filter_by_id(query, String.to_integer(id))

  defp filter_by_id(query, id) do
    from([tag: tag] in query,
      where: tag.id == ^id
    )
  end

  defp filter_by_query(query, nil), do: query

  defp filter_by_query(base_query, query_string) do
    from([tag: tag] in base_query,
      where: ilike(tag.name, ^"%#{query_string}%")
    )
  end

  defp sort_by(query, nil), do: query

  defp sort_by(query, {attr, direction}) do
    from([tag: tag] in query,
      order_by: {^direction, ^attr}
    )
  end

  def search_tags(tags, query) do
    Enum.filter(tags, &String.contains?(&1.name, query))
  end

  def get_tag!(id), do: Repo.get!(Tag, id)

  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  def change_tag(%Tag{} = tag, attrs \\ %{}) do
    Tag.changeset(tag, attrs)
  end

  alias Landover.Taggable.StoryTag

  def list_story_tags do
    Repo.all(StoryTag)
  end

  def get_tagging!(id), do: Repo.get!(StoryTag, id)

  def create_tagging(attrs \\ %{}) do
    %StoryTag{}
    |> StoryTag.changeset(attrs)
    |> Repo.insert()
  end

  def update_tagging(%StoryTag{} = tagging, attrs) do
    tagging
    |> StoryTag.changeset(attrs)
    |> Repo.update()
  end

  def delete_tagging(%StoryTag{} = tagging) do
    Repo.delete(tagging)
  end

  def change_tagging(%StoryTag{} = tagging, attrs \\ %{}) do
    StoryTag.changeset(tagging, attrs)
  end

  def tag_story(story, %{tag: tag_attrs} = attrs) do
    tag = create_or_find_tag(tag_attrs)

    story
    |> Ecto.build_assoc(:story_tags)
    |> StoryTag.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tag, tag)
    |> Repo.insert()
  end

  defp create_or_find_tag(%{name: "" <> name} = attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, tag} -> tag
      _ -> Repo.get_by(Tag, name: name)
    end
  end

  defp create_or_find_tag(_), do: nil

  def delete_tag_from_story(story, tag) do
    Repo.get_by(StoryTag, story_id: story.id, tag_id: tag.id)
    |> case do
      %StoryTag{} = tagging -> Repo.delete(tagging)
      nil -> {:ok, %StoryTag{}}
    end
  end
end
