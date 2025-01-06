defmodule Landover.StoryPromptsTest do
  use Landover.DataCase

  alias Landover.StoryPrompts

  describe "story_prompts" do
    alias Landover.StoryPrompts.StoryPrompt

    import Landover.StoryPromptsFixtures

    @invalid_attrs %{text: nil, order: nil}

    test "list_story_prompts/0 returns all story_prompts" do
      story_prompt = story_prompt_fixture()
      assert StoryPrompts.list_story_prompts() == [story_prompt]
    end

    test "get_story_prompt!/1 returns the story_prompt with given id" do
      story_prompt = story_prompt_fixture()
      assert StoryPrompts.get_story_prompt!(story_prompt.id) == story_prompt
    end

    test "create_story_prompt/1 with valid data creates a story_prompt" do
      valid_attrs = %{text: "some text", order: 42}

      assert {:ok, %StoryPrompt{} = story_prompt} = StoryPrompts.create_story_prompt(valid_attrs)
      assert story_prompt.text == "some text"
      assert story_prompt.order == 42
    end

    test "create_story_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StoryPrompts.create_story_prompt(@invalid_attrs)
    end

    test "update_story_prompt/2 with valid data updates the story_prompt" do
      story_prompt = story_prompt_fixture()
      update_attrs = %{text: "some updated text", order: 43}

      assert {:ok, %StoryPrompt{} = story_prompt} = StoryPrompts.update_story_prompt(story_prompt, update_attrs)
      assert story_prompt.text == "some updated text"
      assert story_prompt.order == 43
    end

    test "update_story_prompt/2 with invalid data returns error changeset" do
      story_prompt = story_prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = StoryPrompts.update_story_prompt(story_prompt, @invalid_attrs)
      assert story_prompt == StoryPrompts.get_story_prompt!(story_prompt.id)
    end

    test "delete_story_prompt/1 deletes the story_prompt" do
      story_prompt = story_prompt_fixture()
      assert {:ok, %StoryPrompt{}} = StoryPrompts.delete_story_prompt(story_prompt)
      assert_raise Ecto.NoResultsError, fn -> StoryPrompts.get_story_prompt!(story_prompt.id) end
    end

    test "change_story_prompt/1 returns a story_prompt changeset" do
      story_prompt = story_prompt_fixture()
      assert %Ecto.Changeset{} = StoryPrompts.change_story_prompt(story_prompt)
    end
  end
end
