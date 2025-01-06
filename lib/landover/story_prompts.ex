defmodule Landover.StoryPrompts do
  @moduledoc """
  The StoryPrompts context.
  """

  import Ecto.Query, warn: false
  alias Landover.Repo

  alias Landover.StoryPrompts.StoryPrompt

  @doc """
  Returns the list of story_prompts.

  ## Examples

      iex> list_story_prompts()
      [%StoryPrompt{}, ...]

  """
  def list_story_prompts do
    Repo.all(StoryPrompt)
  end

  @doc """
  Gets a single story_prompt.

  Raises `Ecto.NoResultsError` if the Story prompt does not exist.

  ## Examples

      iex> get_story_prompt!(123)
      %StoryPrompt{}

      iex> get_story_prompt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_story_prompt!(id), do: Repo.get!(StoryPrompt, id)

  @doc """
  Creates a story_prompt.

  ## Examples

      iex> create_story_prompt(%{field: value})
      {:ok, %StoryPrompt{}}

      iex> create_story_prompt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_story_prompt(attrs \\ %{}) do
    %StoryPrompt{}
    |> StoryPrompt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a story_prompt.

  ## Examples

      iex> update_story_prompt(story_prompt, %{field: new_value})
      {:ok, %StoryPrompt{}}

      iex> update_story_prompt(story_prompt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_story_prompt(%StoryPrompt{} = story_prompt, attrs) do
    story_prompt
    |> StoryPrompt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a story_prompt.

  ## Examples

      iex> delete_story_prompt(story_prompt)
      {:ok, %StoryPrompt{}}

      iex> delete_story_prompt(story_prompt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_story_prompt(%StoryPrompt{} = story_prompt) do
    Repo.delete(story_prompt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking story_prompt changes.

  ## Examples

      iex> change_story_prompt(story_prompt)
      %Ecto.Changeset{data: %StoryPrompt{}}

  """
  def change_story_prompt(%StoryPrompt{} = story_prompt, attrs \\ %{}) do
    StoryPrompt.changeset(story_prompt, attrs)
  end
end
