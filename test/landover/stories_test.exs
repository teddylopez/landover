defmodule Landover.StoriesTest do
  use Landover.DataCase

  alias Landover.Stories

  describe "stories" do
    alias Landover.Stories.Story

    import Landover.StoriesFixtures

    @invalid_attrs %{name: nil, metadata: nil, author_id: nil, completed_at: nil}

    test "list_stories/0 returns all stories" do
      story = story_fixture()
      assert Stories.list_stories() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = story_fixture()
      assert Stories.get_story!(story.id) == story
    end

    test "create_story/1 with valid data creates a story" do
      valid_attrs = %{
        name: "some name",
        metadata: %{},
        author_id: 42,
        completed_at: ~N[2024-12-28 02:05:00]
      }

      assert {:ok, %Story{} = story} = Stories.create_story(valid_attrs)
      assert story.name == "some name"
      assert story.metadata == %{}
      assert story.author_id == 42
      assert story.completed_at == ~N[2024-12-28 02:05:00]
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stories.create_story(@invalid_attrs)
    end

    test "update_story/2 with valid data updates the story" do
      story = story_fixture()

      update_attrs = %{
        name: "some updated name",
        metadata: %{},
        author_id: 43,
        completed_at: ~N[2024-12-29 02:05:00]
      }

      assert {:ok, %Story{} = story} = Stories.update_story(story, update_attrs)
      assert story.name == "some updated name"
      assert story.metadata == %{}
      assert story.author_id == 43
      assert story.completed_at == ~N[2024-12-29 02:05:00]
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = story_fixture()
      assert {:error, %Ecto.Changeset{}} = Stories.update_story(story, @invalid_attrs)
      assert story == Stories.get_story!(story.id)
    end

    test "delete_story/1 deletes the story" do
      story = story_fixture()
      assert {:ok, %Story{}} = Stories.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Stories.get_story!(story.id) end
    end

    test "change_story/1 returns a story changeset" do
      story = story_fixture()
      assert %Ecto.Changeset{} = Stories.change_story(story)
    end
  end
end
