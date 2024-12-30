defmodule Landover.Taggable do
  @moduledoc """
  The Taggable context.
  """

  import Ecto.Query, warn: false
  alias Landover.Repo

  alias Landover.Taggable.Tag
  alias Landover.Taggable.Tagging

  def list_tags do
    Repo.all(Tag)
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

  alias Landover.Taggable.Tagging

  def list_taggings do
    Repo.all(Tagging)
  end

  def get_tagging!(id), do: Repo.get!(Tagging, id)

  def create_tagging(attrs \\ %{}) do
    %Tagging{}
    |> Tagging.changeset(attrs)
    |> Repo.insert()
  end

  def update_tagging(%Tagging{} = tagging, attrs) do
    tagging
    |> Tagging.changeset(attrs)
    |> Repo.update()
  end

  def delete_tagging(%Tagging{} = tagging) do
    Repo.delete(tagging)
  end

  def change_tagging(%Tagging{} = tagging, attrs \\ %{}) do
    Tagging.changeset(tagging, attrs)
  end

  def tag_story(story, %{tag: tag_attrs} = attrs) do
    tag = create_or_find_tag(tag_attrs)

    story
    |> Ecto.build_assoc(:taggings)
    |> Tagging.changeset(attrs)
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
    Repo.get_by(Tagging, story_id: story.id, tag_id: tag.id)
    |> case do
      %Tagging{} = tagging -> Repo.delete(tagging)
      nil -> {:ok, %Tagging{}}
    end
  end
end
