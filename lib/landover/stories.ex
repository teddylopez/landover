defmodule Landover.Stories do
  @moduledoc """
  The Stories context.
  """

  import Ecto.Query, warn: false
  alias Landover.Repo

  alias Landover.Stories.Story

  @doc """
  Returns the list of stories.

  ## Examples

      iex> list_stories()
      [%Story{}, ...]

  """
  def list_stories do
    Repo.all(Story)
  end

  def list_stories(params = %{}) do
    build_query(params)
  end

  defp base_query do
    from(story in Story,
      as: :story
    )
  end

  defp build_query(params) do
    base_query()
    |> filter_by_id(params[:id])
    |> preload_author(params[:preload_author])
    |> sort_by(params[:sort_by])
  end

  defp preload_author(query, nil), do: query

  defp preload_author(query, true) do
    from([story: story] in query,
      preload: :author
    )
  end

  def filter_by_id(query, nil), do: query

  def filter_by_id(query, ids) when is_list(ids) do
    from([story: story] in query,
      where: story.id in ^ids
    )
  end

  def filter_by_id(query, id) when is_integer(id) do
    from([story: story] in query,
      where: story.id == ^id
    )
  end

  def filter_by_id(query, id) when is_binary(id), do: filter_by_id(query, String.to_integer(id))

  defp sort_by(query, nil), do: query

  defp sort_by(query, {field, direction}) do
    from([story: story] in query,
      order_by: {^direction, ^field}
    )
  end

  @doc """
  Gets a single story.

  Raises `Ecto.NoResultsError` if the Story does not exist.

  ## Examples

      iex> get_story!(123)
      %Story{}

      iex> get_story!(456)
      ** (Ecto.NoResultsError)

  """
  def get_story!(id), do: Repo.get!(Story, id)

  @doc """
  Creates a story.

  ## Examples

      iex> create_story(%{field: value})
      {:ok, %Story{}}

      iex> create_story(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_story(attrs \\ %{}) do
    %Story{}
    |> Story.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a story.

  ## Examples

      iex> update_story(story, %{field: new_value})
      {:ok, %Story{}}

      iex> update_story(story, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a story.

  ## Examples

      iex> delete_story(story)
      {:ok, %Story{}}

      iex> delete_story(story)
      {:error, %Ecto.Changeset{}}

  """
  def delete_story(%Story{} = story) do
    Repo.delete(story)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking story changes.

  ## Examples

      iex> change_story(story)
      %Ecto.Changeset{data: %Story{}}

  """
  def change_story(%Story{} = story, attrs \\ %{}) do
    Story.changeset(story, attrs)
  end
end
