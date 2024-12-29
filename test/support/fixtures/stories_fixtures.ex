defmodule Landover.StoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Landover.Stories` context.
  """

  @doc """
  Generate a story.
  """

  import Landover.AccountsFixtures

  def story_fixture(attrs \\ %{}) do
    author = user_fixture()

    {:ok, story} =
      attrs
      |> Enum.into(%{
        completed_at: ~N[2024-12-28 02:05:00],
        author_id: author.id,
        metadata: %{},
        name: "some name"
      })
      |> Landover.Stories.create_story()

    story
  end
end
