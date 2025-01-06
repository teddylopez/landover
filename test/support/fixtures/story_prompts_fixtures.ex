defmodule Landover.StoryPromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Landover.StoryPrompts` context.
  """

  @doc """
  Generate a story_prompt.
  """
  def story_prompt_fixture(attrs \\ %{}) do
    {:ok, story_prompt} =
      attrs
      |> Enum.into(%{
        order: 42,
        text: "some text"
      })
      |> Landover.StoryPrompts.create_story_prompt()

    story_prompt
  end
end
